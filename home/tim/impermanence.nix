# This is *NOT* a home-manager impermanence module, but imported into the NixOS module directly
{
  directories = [
    "Downloads"
    "Music"
    "Pictures"
    "Documents"
    "Videos"
    "projects"
    ".mozilla/firefox"
  ];
  files = [
    ".zsh_history"
    ".ssh/id_ed25519"
  ];
}
