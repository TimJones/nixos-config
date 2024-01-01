{ config
, ...
}: {
  # Use NetworkManager
  users.users.tim.extraGroups = [ "networkmanager" ];

  networking.networkmanager = {
    enable = true;
    ensureProfiles = {
      environmentFiles = [
        config.sops.secrets.networkmanager_env.path
      ];
      profiles = {
        home-wifi = {
          connection = {
            id = "LlamasJones";
            type = "wifi";
          };
          wifi = {
            mode = "infrastructure";
            ssid = "LlamasJones";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$HOME_PSK";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            method = "disabled";
          };
        };
        mum-wifi = {
          connection = {
            id = "VM8335228";
            type = "wifi";
          };
          wifi = {
            mode = "infrastructure";
            ssid = "VM8335228";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$MUM_PSK";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            method = "disabled";
          };
        };
      };
    };
  };
}
