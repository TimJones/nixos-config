{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # Laptop screen
      monitor = "eDP1, highres, auto, 1";

      "$mod" = "SUPER";

      bind = [
	"$mod, Q, killactive"
	"$mod, M, fullscreen, 1" # Maximise
	"$mod, F, fullscreen, 0" # Fullscreen

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
}
