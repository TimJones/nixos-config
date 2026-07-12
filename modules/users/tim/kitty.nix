{
  den.aspects.tim.provides.kitty = {
    homeManager = {
      programs.kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = true;

        # Originally cribbed from DMS settings.
        settings = {
          # Window
          window_padding_width = 4;
          background_blur = 32;
          hide_window_decorations = "yes";

          # Cursor
          cursor_shape = "block";
          cursor_blink_interval = 1;

          # Scrollback & terminal features
          scrollback_lines = 3000;
          copy_on_select = "yes";
          strip_trailing_spaces = "smart";

          # Tab bar styling (colours come from stylix)
          tab_bar_edge = "top";
          tab_bar_style = "powerline";
          tab_powerline_style = "slanted";
          tab_bar_align = "left";
          tab_bar_min_tabs = 2;
          tab_activity_symbol = " ● ";
          tab_numbers_style = 1;
        };

        keybindings = {
          "ctrl+t" = "new_tab_with_cwd";
          "ctrl+shift+n" = "new_tab_with_cwd nvim";
          "ctrl+plus" = "change_font_size all +1.0";
          "ctrl+minus" = "change_font_size all -1.0";
          "ctrl+0" = "change_font_size all 0";
        };
      };
    };
  };
}
