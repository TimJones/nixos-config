{
  inputs,
  ...
}: {
  flake-file.inputs = {
    # I don't want the entirety of NUR just for Firefox extentions.
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.homeManager.firefox =
    { config, ... }:{
    programs.firefox = {
      enable = true;
    };

    home.persistence."/persist" = inputs.self.lib.mkIfPersistence config {
      directories = [
        ".cache/mozilla/firefox"
      ];
    };
  };
}
