{
  den.aspects.tim.provides.nixvim = {
    homeManager = { pkgs, ... }: {
      programs.nixvim = {
        extraPackages = with pkgs; [
          statix
          deadnix
          golangci-lint
          tflint
          yamllint
          markdownlint-cli
        ];

        plugins.lint = {
          enable = true;

          lintersByFt = {
            nix = [
              "nix"
              "statix"
              "deadnix"
            ];
            markdown = [ "markdownlint" ];
            go = [ "golangciclint" ];
            terraform = [ "tflint" ];
            yaml = [ "yamllint" ];
          };
        };

        autoCmd = [
          {
            callback.__raw = ''
              function()
                -- Only run the linter in buffers that you can modify in order to
                -- avoid superfluous noise, notably within the handy LSP pop-ups that
                -- describe the hovered symbol using Markdown.
                if vim.opt_local.modifiable:get() then
                  require('lint').try_lint()
                end
              end
            '';
            group = "lint";
            event = [
              "BufEnter"
              "BufWritePost"
              "InsertLeave"
            ];
          }
        ];

        autoGroups = {
          lint = {
            clear = true;
          };
        };
      };
    };
  };
}
