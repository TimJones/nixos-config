{
  inputs,
  ...
}:
{
  flake.modules.homeManager.tim =
    { config, ... }:
    {
      home = inputs.self.lib.mkIfPersistence config {
        persistence."/persist" = {
          directories = [
            "projects"
          ];
        };
      };
    };
}
