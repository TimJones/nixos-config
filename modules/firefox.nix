{ inputs, ... }:
{
  flake-file.inputs = {
    # I don't want the entirety of NUR just for Firefox extentions.
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.firefox = {
    homeManager = {
      nixpkgs.overlays = [ inputs.firefox-addons.overlays.default ];

      programs.firefox = {
        enable = true;
      };
    };

    permHome.directories = [
      ".cache/mozilla/firefox"
    ];
  };
}
