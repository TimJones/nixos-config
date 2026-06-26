{
  inputs,
  ...
}: {
  flake.modules.homeManager.tim =
    { config, pkgs, ... }:
    let
      addons = inputs.firefox-addons.packages.${pkgs.system};
    in
    {
      programs.firefox.profiles = {
        personal = {
          id = 0;
          isDefault = true;
          extensions = {
            force = true;
            packages = with addons; [
              ublock-origin
              tree-style-tab
            ];
          };

          settings = {
            "browser.search.isUS" = false;
            "general.useragent.locale" = "en-GB";
            "browser.startup.page" = 3; # Load last session
          };
        };
      };
  };
}
