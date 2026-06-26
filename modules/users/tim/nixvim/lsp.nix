{
  # Language servers. Server binaries are pulled in by nixvim automatically.
  flake.modules.homeManager.tim = {
    programs.nixvim.plugins.lsp = {
      enable = true;

      servers = {
        # nixd: nixpkgs-aware Nix language server.
        nixd.enable = true;

        # Go.
        gopls.enable = true;

        # Terraform.
        terraformls.enable = true;

        # YAML, with schemas for Kubernetes / Helm / Kustomize resources.
        yamlls = {
          enable = true;
          settings.schemas = {
            "http://json.schemastore.org/kustomization" = "kustomization.{yml,yaml}";
            "http://json.schemastore.org/chart" = "Chart.{yml,yaml}";
            # Assume any other yaml is kubernetes, not sure how else to detect
            # this elegantly.
            kubernetes = "*.yaml";
          };
        };
      };

      keymaps = {
        diagnostic."<leader>q" = {
          action = "setloclist";
          desc = "Open diagnostic [Q]uickfix list";
        };
        lspBuf = {
          "gd" = {
            action = "definition";
            desc = "LSP: [G]oto [D]efinition";
          };
          "gD" = {
            action = "declaration";
            desc = "LSP: [G]oto [D]eclaration";
          };
          "gr" = {
            action = "references";
            desc = "LSP: [G]oto [R]eferences";
          };
          "K" = {
            action = "hover";
            desc = "LSP: Hover documentation";
          };
          "<leader>rn" = {
            action = "rename";
            desc = "LSP: [R]e[n]ame";
          };
          "<leader>ca" = {
            action = "code_action";
            desc = "LSP: [C]ode [A]ction";
          };
        };
      };
    };
  };
}
