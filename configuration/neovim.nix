{ inputs
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
    };
  };
}
