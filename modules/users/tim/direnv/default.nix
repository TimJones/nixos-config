{ den, ... }:
{
  den.aspects.tim.provides.direnv = {
    includes = [ den.aspects.direnv ];

    homeManager = {
      programs.direnv = {
        stdlib = builtins.readFile ./stdlib.sh;
        enableZshIntegration = true;

        config = {
          global.strict_env = true;
          whitelist.prefix = [
            "~/projects/personal"
            "~/projects/work"
          ];
        };
      };

      xdg.configFile."direnv/envs/core".text = ''
        export KUBECONFIG=~/.kube/core.yaml
        export TALOSCONFIG=~/.talos/core.yaml
      '';
    };
  };
}
