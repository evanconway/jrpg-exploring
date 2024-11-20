/*
	All battle intro animations must accept a battle struct as the first parameter. They must
	set the global.updateable to this battle at the end of their animation.
*/

function battle_get_intro_default(battle_updateable) {
	return {
		battle_updateable,
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
					global.updateable = battle_updateable;
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
