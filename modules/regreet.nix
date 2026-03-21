{
  inputs,
  ...
}:
{
  flake.modules.nixos.regreet =
    { config, lib, ... }:
    {
      programs.regreet = {
        enable = true;
        settings.GTK.application_prefer_dark_theme = true;
      };

      environment = inputs.self.lib.mkIfPersistence config {
        persistence."/persist".directories =
          if lib.versionAtLeast (config.programs.regreet.package.version) "0.2.0" then
            [ "/var/lib/regreet" ]
          else
            [ "/var/cache/regreet" ];
      };
    };
}
