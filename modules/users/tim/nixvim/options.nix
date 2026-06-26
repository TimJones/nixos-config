{
  flake.modules.homeManager.tim = {
    programs.nixvim = {
      defaultEditor = true;

      globals = {
        # Set <space> as the leader key
        mapleader = " ";
        maplocalleader = " ";

        # Using a nerd font
        have_nerd_font = false;
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
          tab = "» ";
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
    };
  };
}
