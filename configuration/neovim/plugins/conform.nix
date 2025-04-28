{ lib
, pkgs
, ...
}: {
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "terraform"
  ];

  programs.nixvim = {
    # Dependencies
    extraPackages = with pkgs; [
      stylua
      gofumpt
      terraform
      yamlfmt
    ];

    # Autoformat
    plugins.conform-nvim = {
      enable = true;
      settings = {
        notify_on_error = false;
        format_on_save = ''
          function(bufnr)
            -- Disable "format_on_save lsp_fallback" for lanuages that don't
            -- have a well standardized coding style. You can add additional
            -- lanuages here or re-enable it for the disabled ones.
            local disable_filetypes = { c = true, cpp = true }
            return {
              timeout_ms = 500,
              lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype]
            }
          end
        '';
        formatters = {
          yamlfmt.prepend_args = [
            "-formatter"
            "retain_line_breaks_single=true,scan_folded_as_literal=true"
          ];
        };
        formatters_by_ft = {
          lua = [ "stylua" ];
          go = [ [ "gofumpt" "gofmt" ] ];
          nix = [ "nixfmt" ];
          tf = [ "terraform fmt" ];
          yaml = [ "yamlfmt" ];
        };
      };
    };

    keymaps = [
      {
        mode = "";
        key = "<leader>f";
        action.__raw = ''
          function()
            require('conform').format { async = true, lsp_fallback = true }
          end
        '';
        options = {
          desc = "[F]ormat buffer";
        };
      }
    ];
  };
}
