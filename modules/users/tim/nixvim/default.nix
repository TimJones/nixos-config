{ den, ... }:
{
  den.aspects.tim.provides.nixvim = {
    includes = [
      den.aspects.nixvim
      (den.batteries.unfree [ "terraform" ]) # For tf formatter/linter/LSP
    ];

    # Configuration originally from https://github.com/JMartJonesy/kickstart.nixvim
    # and that from https://github.com/nvim-lua/kickstart.nvim
    homeManager.programs.nixvim = {
      defaultEditor = true;

      autoGroups = {
        kickstart-highlight-yank = {
          clear = true;
        };
      };

      autoCmd = [
        {
          event = [ "TextYankPost" ];
          desc = "Highlight when yanking (copying) text";
          group = "kickstart-highlight-yank";
          callback.__raw = ''
            function()
              vim.hl.on_yank()
            end
          '';
        }
      ];

      diagnostic = {
        settings = {
          severity_sort = true;
          float = {
            border = "rounded";
            source = "if_many";
          };
          underline = {
            severity.__raw = "vim.diagnostic.severity.ERROR";
          };
          signs.__raw = ''
            vim.g.have_nerd_font and {
              text = {
                [vim.diagnostic.severity.ERROR] = '󰅚 ',
                [vim.diagnostic.severity.WARN] = '󰀪 ',
                [vim.diagnostic.severity.INFO] = '󰋽 ',
                [vim.diagnostic.severity.HINT] = '󰌶 ',
              },
            } or {}
          '';
          virtual_text = {
            source = "if_many";
            spacing = 2;
            format.__raw = ''
              function(diagnostic)
                local diagnostic_message = {
                  [vim.diagnostic.severity.ERROR] = diagnostic.message,
                  [vim.diagnostic.severity.WARN] = diagnostic.message,
                  [vim.diagnostic.severity.INFO] = diagnostic.message,
                  [vim.diagnostic.severity.HINT] = diagnostic.message,
                }
                return diagnostic_message[diagnostic.severity]
              end
            '';
          };
        };
      };

      extraConfigLuaPost = ''
        -- The line beneath this is called `modeline`. See `:help modeline`
        -- vim: ts=2 sts=2 sw=2 et
      '';
    };
  };
}
