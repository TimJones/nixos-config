{ pkgs
, ...
}: {
  home-manager.users.tim = {
    xdg = {
      enable = true;
      configFile."nvim" = {
        source = ./config;
        recursive = true;
      };
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      extraPackages = with pkgs; [
        stylua
      ];

      plugins = with pkgs.vimPlugins; [
        lazy-nvim
        vim-sleuth
        comment-nvim
        gitsigns-nvim
        which-key-nvim
        telescope-nvim
        telescope-fzf-native-nvim
        telescope-ui-select-nvim
        plenary-nvim
        nvim-web-devicons
        nvim-lspconfig
        mason-nvim
        mason-lspconfig-nvim
        mason-tool-installer-nvim
        fidget-nvim
        neodev-nvim
        conform-nvim
        nvim-cmp
        luasnip
        cmp_luasnip
        cmp-nvim-lsp
        cmp-path
        tokyonight-nvim
        todo-comments-nvim
        mini-nvim
        (
          nvim-treesitter.withPlugins (plugins: [
            plugins.awk
            plugins.bash
            plugins.dockerfile
            plugins.git_config
            plugins.git_rebase
            plugins.gitattributes
            plugins.gitcommit
            plugins.gitignore
            plugins.go
            plugins.gomod
            plugins.gosum
            plugins.gotmpl
            plugins.gowork
            plugins.hcl
            plugins.helm
            plugins.html
            plugins.ini
            plugins.jq
            plugins.json
            plugins.lua
            plugins.luadoc
            plugins.make
            plugins.markdown
            plugins.nix
            plugins.ssh_config
            plugins.terraform
            plugins.toml
            plugins.tsv
            plugins.typescript
            plugins.vim
            plugins.vimdoc
            plugins.vue
            plugins.yaml
          ])
        )
      ];
    };
  };
}
