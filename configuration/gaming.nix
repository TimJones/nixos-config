{ lib
, ...
}: {
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-run"
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
  };

  environment.persistence."/persist".users.tim.directories = [
    ".local/share/Steam"
    ".steam"
    ".factorio"
  ];
}
