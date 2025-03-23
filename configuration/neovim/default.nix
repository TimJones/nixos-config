{ inputs
, pkgs
, ...
}: {
  imports = [
    ./plugins/conform.nix
    ./plugins/gitsigns.nix
    ./plugins/which-key.nix
    ./plugins/lsp.nix
    ./plugins/nvim-cmp.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };

    # Settings based on kickstart.nvim
    #  ref - https://github.com/nvim-lua/kickstart.nvim
    #  globals = vim.g.*
    #  options = vim.opt.*

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    globals = {
      # Set <space> as the leader key
      mapleader = " ";
      maplocalleader = " ";

      # Using a nerd font
      have_nerd_font = true;
    };

    opts = {
      # Make line numbers default
      number = true;
      relativenumber = true;

      # Enable mouse mode
      mouse = "a";

      # Don't show the mode, since it's already in the status line
      showmode = false;

      # Enable break indent
      breakindent = true;

      # Save undo history
      undofile = true;

      # Case-insensitive searching UNLESS \C or one or more capital letters in the search term
      ignorecase = true;
      smartcase = true;

      # Keep signcolumn on by default
      signcolumn = "yes";

      # Decrease update time
      updatetime = 250;

      # Decrease mapped sequence wait time
      # Displays which-key popup sooner
      timeoutlen = 300;

      # Configure how new splits should be opened
      splitright = true;
      splitbelow = true;

      # Sets how Neovim will display certain whitespace characters in the editor
      list = true;
      listchars = {
        tab = "»";
        trail = "·";
        nbsp = "␣";
      };

      # Preview substitutions live, as you type!
      inccommand = "split";

      # Show which line your cursor is on
      cursorline = true;

      # Minimal number of screen lines to keep above and below the cursor
      scrolloff = 10;

      # Highligh all search terms
      hlsearch = true;
    };

    keymaps = [
      # Clear highlights on search when pressing <Esc> in normal mode
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
      }

      # Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
      # for people to discover.
      # NOTE: This won't work in all terminal emulators/tmux/etc. May still need to use
      # <C-/><C-n> to exit terminal mode.
      {
        mode = "t";
        key = "<Esc><Esc>";
        action = "<C-\\><C-n>";
        options.desc = "Exit terminal node";
      }

      # Use Ctrl+<hjkl> to switch between windows
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w><C-h>";
        options.desc = "Move focus to the left window";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w><C-l>";
        options.desc = "Move focus to the right window";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w><C-j>";
        options.desc = "Move focus to the lower window";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w><C-k>";
        options.desc = "Move focus to the upper window";
      }

      # Plugin keymaps
      {
        mode = "";
        key = "<leader>f";
        action.__raw = "function() require('conform').format { async = true, lsp_fallback = true } end";
        options.desc = "[F]ormat buffer";
      }
    ];

    autoGroups = {
      kickstart-highlight-yank = {
        clear = true;
      };
    };
    autoCmd = [
      # Highlight when yanking text
      {
        event = "TextYankPost";
        desc = "Highlight when yanking text";
        group = "kickstart-highlight-yank";
        callback = { __raw = "function() vim.highlight.on_yank() end"; };
      }
    ];

    plugins = {
      # Adds icons for plugins to utilize in ui
      web-devicons.enable = true;

      # Detect tabstop and shiftwidth automatically
      sleuth = {
        enable = true;
      };

      # Highlight todo, notes, etc in comments
      todo-comments = {
        settings = {
          enable = true;
          signs = true;
        };
      };
    };

    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraplugins
    extraPlugins = with pkgs.vimPlugins; [
      # Useful for getting pretty icons, requires a Nerd Font.
      nvim-web-devicons
    ];

    extraConfigLuaPre = ''
      if vim.g.have_nerd_font then
        require('nvim-web-devicons').setup {}
      end
    '';

    # Set the default modeline
    extraConfigLuaPost = ''
      -- vim: ts=2 sts=2 sw=2 et
    '';
  };
}
