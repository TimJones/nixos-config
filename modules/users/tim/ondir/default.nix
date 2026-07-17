{ den, lib, ... }:
let
  # Project definitions. The *structure* lives here in the clear (labels, env
  # var names); every value below is a sops secret NAME whose plaintext is
  # substituted in at activation. A secret name doubles as its key path in
  # ../secrets.yaml (nested via `/`), so `ondir/core/dir` reads:
  #
  #   ondir:
  #     core:
  #       dir: projects/work/core     # relative to $HOME
  #       kubeconfig: ~/.kube/core.yaml
  #       talosconfig: ~/.talos/core.yaml
  #
  # sops can't iterate an encrypted list, so add a project by adding an entry
  # here (public) plus its values under `sops <secrets.yaml>` (encrypted).
  projects = {
    core = {
      dir = "ondir/core/dir";
      env = {
        KUBECONFIG = "ondir/core/kubeconfig";
        TALOSCONFIG = "ondir/core/talosconfig";
      };
    };
  };

  # Every secret name referenced above.
  secretNames = lib.concatMap (p: [ p.dir ] ++ lib.attrValues p.env) (lib.attrValues projects);
in
{
  den.aspects.tim.provides.ondir = {
    includes = [ den.aspects.host-secrets ];

    # All sops wiring is host-level: decryption uses the TPM age key, same as
    # the user's SSH key (there is no user age key on the machine).
    nixos =
      { config, ... }:
      let
        userCfg = config.users.users.tim;
        ph = name: config.sops.placeholder.${name};

        mkProject =
          _name: p:
          let
            dir = "${userCfg.home}/${ph p.dir}";
            exports = lib.mapAttrsToList (var: secret: "  export ${var}=${ph secret}") p.env;
            varNames = lib.concatStringsSep " " (lib.attrNames p.env);
          in
          ''
            enter ${dir}
            ${lib.concatStringsSep "\n" exports}
            leave ${dir}
              unset ${varNames}
          '';
      in
      {
        # One secret per referenced value; `key` defaults to the (nested) name.
        sops.secrets = lib.genAttrs secretNames (_: {
          sopsFile = ../secrets.yaml;
        });

        # sops renders ~/.ondirrc with the secret values filled in, at
        # activation -- recreated each boot, so no impermanence persistence
        # is needed (like the SSH key at ~/.ssh/id_ed25519).
        sops.templates.ondirrc = {
          path = "${userCfg.home}/.ondirrc";
          owner = userCfg.name;
          mode = "0600";
          content = lib.concatStringsSep "\n" (lib.mapAttrsToList mkProject projects);
        };
      };

    homeManager =
      { pkgs, ... }:
      let
        ondir = "${pkgs.ondir}/bin/ondir";
      in
      {
        home.packages = [ pkgs.ondir ];

        programs.zsh.initContent = ''
          # ondir: run enter/leave blocks from ~/.ondirrc on directory changes.
          autoload -Uz add-zsh-hook
          _ondir_hook() { eval "$(${ondir} "$OLDPWD" "$PWD")"; }
          add-zsh-hook chpwd _ondir_hook
          # Fire for the shell's starting directory (old="/" enters all ancestors).
          eval "$(${ondir} / "$PWD")"
        '';
      };
  };
}
