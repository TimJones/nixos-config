{
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;

      settings = {
        ensureInstalled = [
          "bash"
          "diff"
          "json"
          "lua"
          "make"
          "markdown"
          "nix"
          "vim"
          "yaml"
        ];

        indent.enable = true;

        highlight = {
          enable = true;
          additional_vim_regex_highlighting = true;
        };
      };
    };
  };
}
