{
  programs.nixvim = {
    # Adds git related signs to the gutter, as well as utilities for managing changes
    plugins.gitsigns = {
      enable = true;
      settings = {
        signs = {
          add.text = "+";
          change.text = "~";
          delete.text = "_";
          topdelete.text = "‾";
          changedelete.text = "~";
        };
      };
    };

    keymaps = [
      # Navigation
      {
        mode = "n";
        key = "]c";
        action.__raw = ''
          function()
            if vim.wo.diff then
              vim.cmd.normal { ']c', bang = true }
            else
              require('gitsigns').nav_hunk 'next'
            end
          end
        '';
        options.desc = "Git: [[] jump to next [C]hange";
      }
      {
        mode = "n";
        key = "[c";
        action.__raw = ''
          function()
            if vim.wo.diff then
              vim.cmd.normal { '[c', bang = true }
            else
              require('gitsigns').nav_hunk 'prev'
            end
          end
        '';
        options.desc = "Git: [[] jump to previous [C]hange";
      }
      # Actions
      # visual mode
      {
        mode = "v";
        key = "<leader>hs";
        action.__raw = ''
          function()
            require('gitsigns').stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end
        '';
        options.desc = "Git: [H]unk [S]tage";
      }
      {
        mode = "v";
        key = "<leader>hr";
        action.__raw = ''
          function()
            require('gitsigns').reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end
        '';
        options.desc = "Git: [H]unk [R]eset";
      }
      # normal mode
      {
        mode = "n";
        key = "<leader>hs";
        action.__raw = ''
          function()
            require('gitsigns').stage_hunk()
          end
        '';
        options.desc = "Git: [H]unk [S]tage";
        };
      }
      {
        mode = "n";
        key = "<leader>hr";
        action.__raw = ''
          function()
            require('gitsigns').reset_hunk()
          end
        '';
        options.desc = "Git: [H]unk [R]eset";
      }
      {
        mode = "n";
        key = "<leader>hS";
        action.__raw = ''
          function()
            require('gitsigns').stage_buffer()
          end
        '';
        options.desc = "Git: [H]unk [S]tage buffer";
      }
      {
        mode = "n";
        key = "<leader>hu";
        action.__raw = ''
          function()
            require('gitsigns').undo_stage_hunk()
          end
        '';
        options.desc = "Git: [H]unk [U]ndo stage";
      }
      {
        mode = "n";
        key = "<leader>hR";
        action.__raw = ''
          function()
            require('gitsigns').reset_buffer()
          end
        '';
        options.desc = "Git: [H]unk [R]eset buffer";
      }
      {
        mode = "n";
        key = "<leader>hp";
        action.__raw = ''
          function()
            require('gitsigns').preview_hunk()
          end
        '';
        options.desc = "Git: [H]unk [P]review";
      }
      {
        mode = "n";
        key = "<leader>hb";
        action.__raw = ''
          function()
            require('gitsigns').blame_line()
          end
        '';
        options.desc = "Git: [H]unk [B]lame";
      }
      {
        mode = "n";
        key = "<leader>hd";
        action.__raw = ''
          function()
            require('gitsigns').diffthis()
          end
        '';
        options.desc = "Git: [H]unk [D]iff against index";
      }
      {
        mode = "n";
        key = "<leader>hD";
        action.__raw = ''
          function()
            require('gitsigns').diffthis '@'
          end
        '';
        options.desc = "Git: [H]unk [D]iff against last commit";
      }
      # Toggles
      {
        mode = "n";
        key = "<leader>tb";
        action.__raw = ''
          function()
            require('gitsigns').toggle_current_line_blame()
          end
        '';
        options.desc = "Git: [T]oggle show [b]lame line";
      }
      {
        mode = "n";
        key = "<leader>tD";
        action.__raw = ''
          function()
            require('gitsigns').toggle_deleted()
          end
        '';
        options.desc = "Git: [T]oggle show [D]eleted";
      }
    ];
  };
}
