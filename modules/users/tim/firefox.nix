{ inputs, ... }:
{
  flake.modules.homeManager.tim =
    { lib, pkgs, ... }:
    let
      addons =
        (import inputs.nixpkgs {
          inherit (pkgs) system;
          overlays = [ inputs.firefox-addons.overlays.default ];
          config.allowUnfreePredicate =
            pkg:
            builtins.elem (lib.getName pkg) [
              "onepassword-password-manager"
            ];
        }).firefox-addons;

      commonAddons = with addons; [
        ublock-origin
        tree-style-tab
      ];

      commonSettings = {
        "browser.search.isUS" = false;
        "general.useragent.locale" = "en-GB";
        "browser.aboutConfig.showWarning" = false;
        "browser.startup.page" = 3; # Load last session
        "browser.profiles.enabled" = false; # Non-declarative profiles
        "extensions.autoDisableScopes" = 0; # Auto-enable side-loaded extensions
        "media.autoplay.default" = 5; # Disable any kind of autoplaying media
      };
    in
    {
      programs.firefox.profiles = {
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
            packages = commonAddons ++ [
              addons.onepassword-password-manager
            ];
          };

          settings = commonSettings;
        };
      };

      xdg.desktopEntries.firefox-work = {
        name = "Firefox (Work)";
        genericName = "Web Browser";
        exec = "firefox -P work --name firefox-work %U";
        icon = "firefox";
        categories = [
          "Network"
          "WebBrowser"
        ];
        startupNotify = true;
      };
    };
}
