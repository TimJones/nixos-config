{ den, ... }:
{
  den.aspects.wireless = {
    includes = [
      den.aspects.network
      den.aspects.sops-nix
    ];

    nixos =
      { config, lib, ... }:
      let
        sopsFile = ./wifi.yaml;

        networks = [
          "home"
          "mum"
          "cate"
          "jiloca"
        ];

        envName = net: suffix: "${lib.toUpper net}_${suffix}";
        envRef = net: suffix: "$" + envName net suffix;
      in
      {
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

        sops.templates."networkmanager.env" = {
          restartUnits = [ "NetworkManager-ensure-profiles.service" ];
          content = lib.concatMapStringsSep "\n" (net: ''
            ${envName net "SSID"}=${config.sops.placeholder."wifi/${net}/ssid"}
            ${envName net "PSK"}=${config.sops.placeholder."wifi/${net}/psk"}
          '') networks;
        };

        networking.networkmanager.ensureProfiles = {
          environmentFiles = [ config.sops.templates."networkmanager.env".path ];

          profiles = lib.listToAttrs (
            map (
              net:
              lib.nameValuePair net {
                connection = {
                  id = net;
                  type = "wifi";
                };
                wifi = {
                  ssid = envRef net "SSID";
                  mode = "infrastructure";
                };
                wifi-security = {
                  key-mgmt = "wpa-psk";
                  psk = envRef net "PSK";
                };
                ipv4.method = "auto";
                ipv6.method = "auto";
              }
            ) networks
          );
        };
      };
  };
}
