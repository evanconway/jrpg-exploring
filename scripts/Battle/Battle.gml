function Battle() constructor {
	static fight = function() {
		// the real battle update loop, not implemented yet
	};
	blackout_alpha = 1;
	static update = function() {
		blackout_alpha -= 0.01;
		if (blackout_alpha <= 0) update = fight;
	};
	draw_background = function () {
		draw_set_color(c_gray);
		draw_set_alpha(1);
		draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
	};
	static draw_blackout = function() {
		if (blackout_alpha > 0) {
			draw_set_color(c_black);
			draw_set_alpha(blackout_alpha);
			draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
		}
	};
	static draw_gui = function() {
		draw_background();
		draw_blackout();
	};
}

function battle_start(get_intro_animation=battle_get_intro_default) {
	global.updateable = get_intro_animation(new Battle());
}
