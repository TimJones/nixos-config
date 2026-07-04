{ den, ... }:
{
  den.aspects.wifi = {
    includes = [ den.aspects.sops-nix ];

    nixos =
      { config, lib, ... }:
      let
        sopsFile = ./wifi.yaml;
        configFilename = "static-networks.conf";

        networks = [
          "home"
          "mum"
          "cate"
          "jiloca"
        ];
      in
      lib.mkMerge [
        {
          networking.wireless = {
            enable = true;
            userControlled = true;
          };
        }

        # VM variant uses 'config.networking.wireless.enable mkForce false;', so no wpa_supplicant.
        # The config here need to be wrapped in the mkIf so it's not included in the VM.
        (lib.mkIf config.networking.wireless.enable {
          networking.wireless.extraConfigFiles = [
            config.sops.templates."${configFilename}".path
          ];

          sops.secrets = lib.listToAttrs (
            lib.concatMap (net: [
              (lib.nameValuePair "wifi/${net}/ssid" {
                inherit sopsFile;
                key = "${net}/ssid";
              })
              (lib.nameValuePair "wifi/${net}/psk" {
                inherit sopsFile;
                key = "${net}/psk";
              })
            ]) networks
          );

          sops.templates."${configFilename}" = {
            path = "/etc/wpa_supplicant/${configFilename}";
            owner = "wpa_supplicant";
            restartUnits = [ "wpa_supplicant.service" ];
            content = lib.concatMapStringsSep "\n" (net: ''
              network={
                ssid="${config.sops.placeholder."wifi/${net}/ssid"}"
                psk="${config.sops.placeholder."wifi/${net}/psk"}"
              }
            '') networks;
          };
        })
      ];
  };
}
