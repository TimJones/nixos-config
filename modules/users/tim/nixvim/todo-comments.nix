{
  den.aspects.tim.provides.nixvim = {
    homeManager.programs.nixvim = {
      plugins.todo-comments = {
        enable = true;
        settings.signs = false;
      };
    };
  };
}
