{ den, ... }:
{
  den.aspects.steam = {
    includes = [
      (den.batteries.unfree [
        "steam"
        "steam-unwrapped"
      ])
    ];

    nixos =
      { pkgs, ... }:
      {
        programs = {
          gamescope = {
            enable = true;
            capSysNice = true;
          };

          steam = {
            enable = true;
            remotePlay.openFirewall = true;
            gamescopeSession.enable = true;
            dedicatedServer.openFirewall = true;
            extraPackages = [ pkgs.hidapi ];
            extraCompatPackages = [ pkgs.proton-ge-bin ];
          };
        };
      };
  };
}
