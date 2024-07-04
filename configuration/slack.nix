{ pkgs
, ...
}: {
  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      slack
      slack-cli
    ];

    sessionVariables.NIXOS_OZONE_WL = "1";

    persistence."/persist".users.tim.directories = [
      ".config/Slack"
    ];
  };
}
