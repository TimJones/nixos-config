{
  flake.modules.nixos.wifi-settings =
    let
      ssids = [ "LlamasJones" "VM6784418" "VM6425419" "MOVISTAR_DC50" ];

      mkWifiSecret = ssid: {
        name = "wifi/${ssid}";
        value = {
          sopsFile = ./wifi-psks.yaml;
          key = ssid;
        };
      };

      mkWifiNetwork = ssid: {
        name = ssid;
        value.pskRaw = "ext:${ssid}_psk";
      };
    in
    { config, lib, ... }:
    {
      sops = {
        secrets = lib.listToAttrs (map mkWifiSecret ssids);
        templates."wifi-keys" = {
          owner = "wpa_supplicant";
          content = lib.concatMapStrings (ssid: "${ssid}_psk=${config.sops.placeholder."wifi/${ssid}"}\n") ssids;
        };
      };

      networking.wireless = {
        enable = true;
        userControlled = true;
        secretsFile = config.sops.templates."wifi-keys".path;
        networks = lib.listToAttrs (map mkWifiNetwork ssids);
      };
  };
}
