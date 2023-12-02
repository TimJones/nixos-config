{
  imports = [
    ./development.nix
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
