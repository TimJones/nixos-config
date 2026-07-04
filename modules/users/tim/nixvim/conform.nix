{
  den.aspects.tim.provides.nixvim = {
    homeManager = { pkgs, ... }: {
      programs.nixvim = {
        extraPackages = with pkgs; [
          nixfmt
          gofumpt
          terraform
          yamlfmt
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
  };
}
