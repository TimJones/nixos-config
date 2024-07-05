{
  home-manager.users.tim.services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";

    settings = [
      {
        profile = {
          name = "undocked";
          outputs = [
            {
              criteria = "eDP-1";
              position = "0,0";
            }
          ];
        };
      }
      {
        profile = {
          name = "homeDock";
          outputs = [
            {
              criteria = "LG Electronics LG ULTRAGEAR 102NTVS35511";
              adaptiveSync = true;
              position = "0,0";
            }
            {
              criteria = "Dell Inc. DELL U2713HM 7JNY5431996S";
              position = "440,-1440";
            }
            {
              criteria = "eDP-1";
              position = "3440,0";
            }
          ];
        };
      }
    ];
  };
}
