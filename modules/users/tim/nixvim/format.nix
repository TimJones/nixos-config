{
  # Formatting via conform-nvim. Formats on save, plus a manual <leader>f.
  # Formatter choices match the flake/repo conventions where applicable.
  flake.modules.homeManager.tim =
    { pkgs, ... }:
    {
      programs.nixvim = {
        extraPackages = with pkgs; [
          nixfmt # nix (matches the flake's `formatter`)
          gofumpt # go (stricter gofmt)
          terraform # terraform fmt
          yamlfmt # yaml
        ];

        plugins.conform-nvim = {
          enable = true;
          settings = {
            notify_on_error = false;
            format_on_save = {
              timeout_ms = 500;
              lsp_format = "fallback";
            };
            formatters.yamlfmt.prepend_args = [
              "-formatter"
              "retain_line_breaks_single=true,scan_folded_as_literal=true"
            ];
            formatters_by_ft = {
              nix = [ "nixfmt" ];
              go = [ "gofumpt" ];
              terraform = [ "terraform_fmt" ];
              yaml = [ "yamlfmt" ];
            };
          };
        };

        keymaps = [
          {
            mode = "n";
            key = "<leader>f";
            action.__raw = "function() require('conform').format { async = true, lsp_format = 'fallback' } end";
            options.desc = "[F]ormat buffer";
          }
        ];
      };
    };
}
