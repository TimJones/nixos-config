{ lib
, ...
}: {
  programs.zsh.enable = true;

  home-manager.users.tim.programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = true;
        format = lib.concatStrings [
          "[ ](bg:blue fg:base)"
          "$username"
          "[@](bg:blue fg:base)"
          "$hostname"
          "[ ](bg:sky fg:blue)"
          "$directory"
          "[ ](bg:green fg:sky)"
          "$git_branch"
          "$git_state"
          "$git_commit"
          "$git_metrics"
          "$git_status"
          "[ ](bg:peach fg:green)"
          "$nix_shell"
          "[](peach)"
          "$fill"
          "[](red)"
          "($azure)($aws)($gcloud)"
          "[ ](bg:red fg:pink)"
          "$kubernetes"
          "[ ](bg:pink fg:rosewater)"
          "$status"
          "[ ](bg:rosewater fg:base)"
          "$line_break"
          "$character"
        ];

        username = {
          show_always = true;
          format = "[$user]($style)";
          style_root = "bg:blue fg:bold red";
          style_user = "bg:blue fg:bold base";
        };

        hostname = {
          ssh_only = false;
          format = "[$hostname$ssh_symbol]($style)";
          style = "bg:blue fg:bold base";
        };

        directory = {
          truncate_to_repo = false;
          truncation_length = 5;
          fish_style_pwd_dir_length = 3;
          style = "bg:sky fg:bold base";
          read_only_style = "bg:sky";
          repo_root_style = "bg:sky fg:bold base";
          before_repo_root_style = "bg:sky fg:base";
          format = "[$path]($style)[$read_only]($read_only_style)";
          repo_root_format = "[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style)";
        };

        git_branch = {
          style = "bg:green fg:bold base";
          format = "[$symbol$branch(:$remote_branch) ]($style)";
        };

        git_state = {
          style = "bg:green fg:base";
          format = "\([$state( $progress_current/$progress_total) ]($style)\)";
        };

        git_commit = {
          style = "bg:green fg:base";
          format = "[\($hash$tag\) ]($style)";
          tag_disabled = false;
          only_detached = false;
        };

        git_metrics = {
          disabled = false;
          added_style = "bg:green fg:base";
          deleted_style = "bg:green fg:base";
          format = "[([+$added]($added_style) )([-$deleted]($deleted_style) )](bg:green)";
        };

        git_status = {
          style = "bg:green fg:base";
          format = "([\\[$all_status$ahead_behind\\]]($style))";
        };

        nix_shell = {
          style = "bg:peach fg:bold base";
          format = "[$symbol$state( \($name\)) ]($style)";
        };

        fill = {
          style = "overlay0";
          symbol = "─";
        };

        aws = {
          style = "bg:red fg:base";
          format = "[$symbol ($profile )(\($region\) )(\[$duration\] )]($style)";
          symbol = "";
        };

        azure= {
          disabled = false;
          style = "bg:red fg:base";
          format = "[$symbol ($subscription)]($style)";
          symbol = "";
        };

        gcloud = {
          style = "bg:red fg:base";
          format = "[$symbol$account(@$domain)(\($region\))]($style)";
          symbol = "";
        };

        kubernetes = {
          disabled = false;
          style = "bg:pink fg:bold base";
          format = "[$symbol$context( \($namespace\))]($style)";
        };

        status = {
          map_symbol = true;
          style = "bg:rosewater fg:bold base";
          format = "[$symbol$status]($style)";
        };

        palette = "catppuccin_mocha";
        palettes.catppuccin_mocha = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };
      };
    };

    zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      enableVteIntegration = true;
      autosuggestion.enable = true;

      history.ignoreAllDups = true;

      dirHashes = {
        personal = "~/projects/personal";
        work = "~/projects/siderolabs";
      };
    };
  };

  environment.persistence."/persist".users.tim = {
    files = [
      ".zsh_history"
    ];
    directories = [
      ".local/share/direnv"
    ];
  };
}
