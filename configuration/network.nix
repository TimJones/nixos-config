{ config
, ...
}: {
  # Allow user to manage networks
  users.users.tim.extraGroups = [ "networkmanager" ];

  # Save ad-hoc network configs
  environment.persistence."/persist".directories = [
    {
      directory = "/etc/NetworkManager/system-connections";
      mode = "u=rwx,g=,o=";
    }
  ];

  # Store PSKs in SOPS
  sops.secrets = {
    "wifi/home/psk" = { };
    "wifi/mum/psk" = { };
    "wifi/jiloca/psk" = { };
  };
  # And create files that can be used with envsubst
  sops.templates."wifi-psk.env".content = ''
    HOME_PSK=${config.sops.placeholder."wifi/home/psk"}
    MUM_PSK=${config.sops.placeholder."wifi/mum/psk"}
    JILOCA_PSK=${config.sops.placeholder."wifi/jiloca/psk"}
  '';

  # Use NetworkManager
  programs.nm-applet.enable = true;
  networking.networkmanager = {
    enable = true;
    ensureProfiles = {
      environmentFiles = [
        config.sops.templates."wifi-psk.env".path
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
        jiloca-wifi = {
          connection = {
            id = "MOVISTAR_DC50";
            type = "wifi";
          };
          wifi = {
            mode = "infrastructure";
            ssid = "MOVISTAR_DC50";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$JILOCA_PSK";
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
