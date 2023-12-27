{
  inputs,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];
  
  home.persistence."/persist/home/tim" = {
    allowOther = false;
    directories = [
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      "projects"
    ];
    files = [
      ".zsh_history"
    ];
  };
}
