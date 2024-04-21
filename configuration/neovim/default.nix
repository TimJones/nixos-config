{ inputs
, pkgs
, ...
}: {
  home-manager.users.tim = {
    imports = [
      inputs.nixvim.homeManagerModules.nixvim
    ];

    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      colorschemes.tokyonight.enable = true;

      clipboard = {
        register = "unnamedplus";
        providers.wl-copy.enable = true;
      };

      # Settings based on kickstart.nvim
      #  ref - https://github.com/nvim-lua/kickstart.nvim
      #  globals = vim.g.*
      #  options = vim.opt.*

      # Set <space> as the leader key
      globals.mapleader = " ";
      globals.maplocalleader = " ";

      # Using a nerd font
      globals.have_nerd_font = true;

      # Make line numbers default
      options.number = true;
      options.relativenumber = true;

      # Enable mouse mode
      options.mouse = "a";

      # Don't show the mode, since it's already in the status line
      options.showmode = false;

      # Enable break indent
      options.breakindent = true;

      # Save undo history
      options.undofile = true;

      # Case-insensitive searching UNLESS \C or one or more capital letters in the search term
      options.ignorecase = true;
      options.smartcase = true;

      # Keep signcolumn on by default
      options.signcolumn = "yes";

      # Decrease update time
      options.updatetime = 250;

      # Decrease mapped sequence wait time
      # Displays which-key popup sooner
      options.timeoutlen = 300;

      # Configure how new splits should be opened
      options.splitright = true;
      options.splitbelow = true;

      # Sets how Neovim will display certain whitespace characters in the editor
      options.list = true;
      options.listchars = {
        tab = "» ";
        trail = "·";
        nbsp = "␣";
      };

      # Preview substitutions live, as you type!
      options.inccommand = "split";

      # Show which line your cursor is on
      options.cursorline = true;

      # Minimal number of screen lines to keep above and below the cursor
      options.scrolloff = 10;

      keymaps = [
        # Diagnostic keymaps
        {
          mode = "n";
          key = "[d";
          action = "vim.diagnostic.goto_prev";
          lua = true;
          options.desc = "Go to previous [D]iagnostic message";
        }
        {
          mode = "n";
          key = "]d";
          action = "vim.diagnostic.goto_next";
          lua = true;
          options.desc = "Go to next [D]iagnostic message";
        }
        {
          mode = "n";
          key = "<leader>e";
          action = "vim.diagnostic.open_float";
          lua = true;
          options.desc = "Show diagnostic [E]rror messages";
        }
        {
          mode = "n";
          key = "<leader>q";
          action = "vim.diagnostic.setloclist";
          lua = true;
          options.desc = "Open diagnostic [Q]uickfix list";
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
          action = "function() require('conform').format { async = true, lsp_fallback = true } end";
          lua  = true;
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

      plugins.conform-nvim = {
        formattersByFt = {
          lua = [ "stylua" ];
        };
        formatOnSave = ''
          function(bufnr)
            local disable_filetypes = { c = true, cpp = true }
            return {
              timeout_ms = 500,
              lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
            }
          end
        '';
      };

      plugins.lazy = {
        enable = true;
        plugins = with pkgs.vimPlugins; [
          vim-sleuth
          comment-nvim
          {
            pkg = gitsigns-nvim;
            opts = {
              signs = {
                add = { text = "+"; };
                change = { text = "~"; };
                delete = { text = "_"; };
                topdelete = { text = "‾"; };
                changedelete = { text = "~"; };
              };
            };
          }
          {
            pkg = which-key-nvim;
            event = "VimEnter";
            config = builtins.readFile config/which-key.lua;
          }
          {
            pkg = telescope-nvim;
            dependencies = [
              plenary-nvim
              telescope-fzf-native-nvim
              telescope-ui-select-nvim
              nvim-web-devicons
            ];
            config = builtins.readFile config/telescope.lua;
          }
          {
            pkg = nvim-lspconfig;
            dependencies = [
              fidget-nvim
              neodev-nvim
            ];
            config = builtins.readFile config/lspconfig.lua;
          }
          {
            pkg = nvim-cmp;
            event = "InsertEnter";
            dependencies = [
              luasnip
              cmp_luasnip
              cmp-nvim-lsp
              cmp-path
            ];
            config = builtins.readFile config/nvim-cmp.lua;
          }
          {
            pkg = todo-comments-nvim;
            event = "VimEnter";
            dependencies = [
              plenary-nvim
            ];
            opts = {
              signs = false;
            };
          }
        ];
      };
    };
  };
}
#     xdg = {
#       enable = true;
#       configFile."nvim" = {
#         source = ./config;
#         recursive = true;
#       };
#     };
#
#     programs.neovim = {
#       enable = true;
#       defaultEditor = true;
#
#       viAlias = true;
#       vimAlias = true;
#       vimdiffAlias = true;
#
#       extraPackages = with pkgs; [
#         lua-language-server
#         ripgrep
#         stylua
#       ];
#
#       plugins = with pkgs.vimPlugins; [
#         lazy-nvim
#         vim-sleuth
#         comment-nvim
#         gitsigns-nvim
#         which-key-nvim
#         telescope-nvim
#         telescope-fzf-native-nvim
#         telescope-ui-select-nvim
#         plenary-nvim
#         nvim-web-devicons
#         nvim-lspconfig
#         fidget-nvim
#         neodev-nvim
#         conform-nvim
#         nvim-cmp
#         luasnip
#         cmp_luasnip
#         cmp-nvim-lsp
#         cmp-path
#         tokyonight-nvim
#         todo-comments-nvim
#         mini-nvim
#         (
#           nvim-treesitter.withPlugins (p: [
#             p.awk
#             p.bash
#             p.dockerfile
#             p.git_config
#             p.git_rebase
#             p.gitattributes
#             p.gitcommit
#             p.gitignore
#             p.go
#             p.gomod
#             p.gosum
#             p.gotmpl
#             p.gowork
#             p.hcl
#             p.helm
#             p.html
#             p.ini
#             p.jq
#             p.json
#             p.lua
#             p.luadoc
#             p.make
#             p.markdown
#             p.nix
#             p.ssh_config
#             p.terraform
#             p.toml
#             p.tsv
#             p.typescript
#             p.vim
#             p.vimdoc
#             p.vue
#             p.yaml
#           ])
#         )
#       ];
#     };
#   };
# }
