{
  den.aspects.tim.provides.nixvim = {
    homeManager.programs.nixvim = {
      globals = {
        mapleader = " ";
        maplocalleader = " ";
        have_nerd_font = true;
      };

      opts = {
        number = true;
        relativenumber = true;
        mouse = "a";
        showmode = false;
        breakindent = true;
        undofile = true;
        ignorecase = true;
        smartcase = true;
        signcolumn = "yes";
        updatetime = 250;
        timeoutlen = 300;
        splitright = true;
        splitbelow = true;
        list = true;
        listchars = {
          tab = "» ";
          trail = "·";
          nbsp = "␣";
        };
        inccommand = "split";
        cursorline = true;
        scrolloff = 10;
        confirm = true;
        hlsearch = true;
      };
    };
  };
}
