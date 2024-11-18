function battle_start() {
	global.updateable = {
		time: 0,
		update: function() {
			time += 1;
			if (time > 60) global.updateable = global.world;
		},
		draw: world_draw,
		draw_gui: function() {
			draw_set_color(c_black);
			draw_set_alpha(0.5);
			draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
		}
	};
}