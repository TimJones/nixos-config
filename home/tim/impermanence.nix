# This is *NOT* a home-manager impermanence module, but imported into the NixOS module directly
{
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
}
