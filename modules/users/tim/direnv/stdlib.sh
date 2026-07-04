# Automatically source out-of-tree env file if it exists
if [ -f "${HOME}"/.config/direnv/envs/$(basename "${PWD}")" ]; then
  source_env "${HOME}"/.config/direnv/envs/$(basename "${PWD}")"
fi
