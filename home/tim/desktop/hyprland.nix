{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # Laptop screen
      monitor = "eDP1, highres, auto, 1";

      "$mod" = "SUPER";

      exec-once = [
        "dunst"
        "waybar"
      ];

      bind = [
        "$mod, Q, exit"
        "$mod, C, killactive"
	"$mod, M, fullscreen, 1" # Maximise
	"$mod, F, fullscreen, 0" # Fullscreen

	# App launchers
	"$mod, return, exec, kitty"
	"$mod, R, exec, wofi --show drun"

	# Move window focus
	"$mod, left, movefocus, l"
	"$mod, right, movefocus, r"
	"$mod, up, movefocus, u"
	"$mod, down, movefocus, d"

	# Scratchpad
	"$mod, S, togglespecialworkspace, magic"
	"$mod SHIFT, S, movetoworkspace, special:magic"

	# Switch workspaces...
	"$mod, 1, workspace, 1"
	"$mod, 2, workspace, 2"
	"$mod, 3, workspace, 3"
	"$mod, 4, workspace, 4"
	"$mod, 5, workspace, 5"
	"$mod, 6, workspace, 6"
	"$mod, 7, workspace, 7"
	"$mod, 8, workspace, 8"
	"$mod, 9, workspace, 9"
	"$mod, 0, workspace, 10"
        # ...by scrolling the mousewheel
	"$mod, mouse_down, workspace, e+1"
	"$mod, mouse_up, workspace, e-1"

	# Move active window to workspace
	"$mod SHIFT, 1, movetoworkspace, 1"
	"$mod SHIFT, 2, movetoworkspace, 2"
	"$mod SHIFT, 3, movetoworkspace, 3"
	"$mod SHIFT, 4, movetoworkspace, 4"
	"$mod SHIFT, 5, movetoworkspace, 5"
	"$mod SHIFT, 6, movetoworkspace, 6"
	"$mod SHIFT, 7, movetoworkspace, 7"
	"$mod SHIFT, 8, movetoworkspace, 8"
	"$mod SHIFT, 9, movetoworkspace, 9"
	"$mod SHIFT, 0, movetoworkspace, 10"
      ];
    };
  };

  programs.wofi = {
    enable = true;

    style = ''
      *{
          font-family: monospace;
      }
      
      window {
          margin: 5px;
          border: 0px solid white;
          background-color: rgba(48, 98, 148, 1.0);
      }
      
      #input {
          margin: 5px;
          border-radius: 0px;
          border: none;
          border-bottom: 0px solid black;
          background-color: #1A1C1E;
          color: white;
      }
      
      #inner-box {
          margin: 5px;
          background-color: #1A1C1E;
      }
      
      #outer-box {
          margin: 5px;
          padding:20px;
          background-color: #1A1C1E;
      }
      
      #scroll {
      }
      
      #text {
          margin: 5px;
          color: white;
      }
      
      #entry:selected {
          background-color: #151718;
      }
      
      #text:selected {
          text-decoration-color: white;
      }
    '';
  };

  services.dunst.enable = true;
  programs.waybar.enable = true;
}
