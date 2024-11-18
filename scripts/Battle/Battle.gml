function battle_create() {
	return {
		blackout_alpha: 1,
		update: function() {
			blackout_alpha -= 0.01;
			if (blackout_alpha < -0.2) global.updateable = global.world;
		},
		draw_gui: function() {
			draw_set_color(c_gray);
			draw_set_alpha(1);
			draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
			
			if (blackout_alpha > 0) {
				draw_set_color(c_black);
				draw_set_alpha(blackout_alpha);
				draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
			}
		},
	};
}

// feather ignore GM1043
function battle_start() {
	global.updateable = {
		time: 0,
		blackout_alpha: 0,
		flash_cycle_time: 14,
		number_of_flash_cycles: 4,
		step: 0,
		steps: [
			function() {
				var mod_flash = time % flash_cycle_time;
				blackout_alpha = mod_flash < (flash_cycle_time / 2) ? 0.5 : 0;
				if (time >= (flash_cycle_time * number_of_flash_cycles) - 1) {
					blackout_alpha = 0;
					step += 1;
				}
			},
			function() {
				blackout_alpha += 0.012;
				if (blackout_alpha >= 1) {
					global.updateable = battle_create();
				}
			},
		],
		update: function() {
			time += 1;
			steps[step]();
		},
		draw: world_draw,
		draw_gui: function() {
			if (blackout_alpha > 0) {
				draw_set_color(c_black);
				draw_set_alpha(blackout_alpha);
				draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
			}
		}
	};
}
