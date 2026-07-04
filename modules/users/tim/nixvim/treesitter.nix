{
  den.aspects.tim.provides.nixvim = {
    homeManager =
      { pkgs, ... }:
      {
        programs.nixvim = {
          plugins.treesitter = {
            enable = true;
            nixvimInjections = true;

            grammarPackages = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [
              # This flake / Neovim config.
              nix
              lua
              luadoc
              vim
              vimdoc
              query

              # Languages & tooling in use (see lsp.nix / conform.nix / lint.nix).
              bash
              go
              gomod
              gosum
              gowork
              terraform
              hcl
              yaml
              make
              markdown
              markdown_inline

              # Config & data files.
              json
              toml
              dockerfile

              # Git.
              diff
              gitcommit
              gitignore
              git_rebase
              gitattributes
            ];

            settings = {
              highlight.enable = true;
              indent.enable = true;
            };
          };
        };
      };
  };
}
