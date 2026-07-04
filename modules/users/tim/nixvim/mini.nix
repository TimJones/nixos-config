{
  den.aspects.tim.provides.nixvim = {
    homeManager.programs.nixvim = {
      plugins.mini = {
        enable = true;
        mockDevIcons = true;

        modules = {
          # File/glyph icons. Required for `mockDevIcons` to have any effect.
          icons = { };

          # Better around/inside text objects, e.g. `va)`, `yinq`, `ci'`.
          ai.n_lines = 500;

          # Add/delete/replace surroundings, e.g. `saiw)`, `sd'`, `sr)'`.
          surround = { };

          # Simple and lightweight statusline. Icons come from mini.icons.
          statusline.use_icons = true;
        };
      };
    };
  };
}
