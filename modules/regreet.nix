{
  den.aspects.regreet = {
    nixos = {
      programs.regreet = {
        enable = true;
        settings.GTK.application_prefer_dark_theme = true;
      };

    };

    permSys = { config, lib, ... }: {
      directories =
        if lib.versionAtLeast config.programs.regreet.package.version "0.2.0" then
          [ "/var/lib/regreet" ]
        else
          [ "/var/cache/regreet" ];
    };
  };
}
