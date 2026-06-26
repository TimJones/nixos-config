{
  # Linting via nvim-lint. nvim-lint doesn't run automatically, so trigger it
  # from an autocmd. Linter binaries come from extraPackages below.
  flake.modules.homeManager.tim =
    { pkgs, ... }:
    {
      programs.nixvim = {
        extraPackages = with pkgs; [
          statix # nix: anti-patterns
          deadnix # nix: dead code
          golangci-lint # go
          tflint # terraform
          yamllint # yaml
        ];

        plugins.lint = {
          enable = true;
          lintersByFt = {
            nix = [
              "statix"
              "deadnix"
            ];
            go = [ "golangcilint" ];
            terraform = [ "tflint" ];
            yaml = [ "yamllint" ];
          };
        };

        autoGroups.nvim-lint.clear = true;
        autoCmd = [
          {
            event = [
              "BufWritePost"
              "BufReadPost"
              "InsertLeave"
            ];
            group = "nvim-lint";
            callback.__raw = "function() require('lint').try_lint() end";
          }
        ];
      };
    };
}
