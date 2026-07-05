{ den, ... }:
{
  den.aspects.tim.provides.firefox = {
    includes = [
      den.aspects.firefox
      (den.batteries.unfree [ "onepassword-password-manager" ])
    ];

    homeManager =
      { lib, pkgs, ... }:
      let
        addons = pkgs.firefox-addons;

        commonAddons = with addons; [
          ublock-origin
        ];

        commonSettings = {
          "general.useragent.locale" = "en-GB";
          "distribution.searchplugins.defaultLocale" = "en-GB";
          "extensions.pocket.enabled" = false;
          "extensions.autoDisableScopes" = 0; # Auto-enable side-loaded extensions
          "media.autoplay.default" = 5; # Disable any kind of autoplaying media
          "signon.rememberSignons" = false; # Don't save passwords in browser
          "widget.use-xdg-desktop-portal.file-picker" = 1;

          "browser.search.isUS" = false;
          "browser.startup.page" = 3; # Load last session
          "browser.shell.checkDefaultBrowser" = false;
          "browser.startup.firstrunSkipsHomepage" = false;
          "browser.profiles.enabled" = false; # Non-declarative profiles
          "browser.aboutConfig.showWarning" = false; # Use about:config without annoying "are you sure?".
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

          "sidebar.verticalTabs" = true;
          "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;

          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.userContext.enabled" = true; # Enable Container Tabs
          "privacy.userContext.ui.enabled" = true;
        };

        mkNixSearch = name: alias: {
          name = "Nix ${lib.toSentenceCase name}";
          urls = [
            {
              template = "https://search.nixos.org/${name}";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "type";
                  value = name;
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ alias ];
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

              search = {
                force = true;
                default = "ddg";
                order = [
                  "ddg"
                  "google"
                ];

                engines = {
                  nix-options = mkNixSearch "options" "@no";
                  nix-packages = mkNixSearch "packages" "@np";

                  nixos-wiki = {
                    name = "NixOS Wiki";
                    urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
                    iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
                    definedAliases = [ "@nw" ];
                  };

                  word-reference-en = {
                    name = "Word Reference - Engish to Spanish";
                    urls = [
                      { template = "https://www.wordreference.com/redirect/translation.aspx?dict=enes&w={searchTerms}"; }
                    ];
                    definedAliases = [ "@en" ];
                  };

                  word-reference-es = {
                    name = "Word Reference - Spanish to English";
                    urls = [
                      { template = "https://www.wordreference.com/redirect/translation.aspx?dict=esen&w={searchTerms}"; }
                    ];
                    definedAliases = [ "@es" ];
                  };
                };
              };
            };

            work = {
              id = 1;
              isDefault = false;
              extensions = {
                force = true;
                packages = commonAddons ++ [ addons.onepassword-password-manager ];
              };

              settings = commonSettings;
              search = {
                force = true;
                default = "ddg";
                order = [
                  "ddg"
                  "google"
                ];
              };
            };
          };
        };

        # Extra entry to launch
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
  };
}
