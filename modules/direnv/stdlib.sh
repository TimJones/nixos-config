# Automatically source an out-of-tree file if it exists
if [ -f "$HOME/.config/direnv/envs/$(basename "$PWD")" ]; then
  source_env "$HOME/.config/direnv/envs/$(basename "$PWD")"
fi
