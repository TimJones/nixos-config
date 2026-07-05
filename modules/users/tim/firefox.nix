{ den, ... }:
{
  den.aspects.tim.provides.firefox = {
    includes = [
      den.aspects.firefox
      (den.batteries.unfree [ "onepassword-password-manager" ])
    ];

    homeManager =
      { pkgs, ... }:
      let
        addons = pkgs.firefox-addons;

        commonAddons = with addons; [
          ublock-origin
          tree-style-tab
        ];

        commonSettings = {
          "browser.search.isUS" = false;
          "general.useragent.locale" = "en-GB";
          "browser.startup.page" = 3; # Load last session
          "browser.profiles.enabled" = false; # Non-declarative profiles
          "extensions.autoDisableScopes" = 0; # Auto-enable side-loaded extensions
          "media.autoplay.default" = 5; # Disable any kind of autoplaying media
        };
      in
      {
        programs.firefox = {
          profiles = {
            personal = {
              id = 0;
              isDefault = true;
              extensions = {
                force = true;
                packages = commonAddons;
              };

              settings = commonSettings;
            };

            work = {
              id = 1;
              isDefault = false;
              extensions = {
                force = true;
                packages = commonAddons ++ [ addons.onepassword-password-manager ];
              };

              settings = commonSettings;
            };
          };
        };
      };
  };
}
