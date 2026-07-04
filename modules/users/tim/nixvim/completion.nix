{
  den.aspects.tim.provides.nixvim = {
    homeManager.programs.nixvim = {
      plugins.luasnip.enable = true;
      plugins.blink-cmp = {
        enable = true;

        settings = {
          appearance.nerd_font_variant = "mono";
          snippets.preset = "luasnip";

          # 'default' (super-tab style) keymap:
          #   <c-y> accept, <c-space> open menu / docs, <c-n>/<c-p> or arrows
          #   to select, <c-e> hide, <c-k> toggle signature.
          keymap.preset = "default";

          # Show docs on demand (<c-space>) rather than automatically.
          completion.documentation.auto_show = false;

          sources = {
            default = [
              "lsp"
              "path"
              "snippets"
              "lazydev"
            ];
            # Pull in Neovim runtime completions from lazydev (see lsp.nix) and
            # rank them above LSP results.
            providers.lazydev = {
              name = "LazyDev";
              module = "lazydev.integrations.blink";
              score_offset = 100;
            };
          };

          fuzzy.implementation = "lua";
          signature.enabled = true;
        };
      };
    };
  };
}
