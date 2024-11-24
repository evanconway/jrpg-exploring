/*
	All battle intro animations must accept a battle struct as the first parameter. They must
	set the global.updateable to this battle at the end of their animation.
*/

function battle_get_intro_default(battle_updateable) {
	return {
		battle_updateable,
		update: function() {
			global.updateable = battle_updateable;
		}
	};
}

function battle_get_intro_flash_fade(battle_updateable) {
	return {
		battle_updateable,
		time: 0,
		blackout_alpha: 0,
		flash_cycle_time: 233,
		number_of_flash_cycles: 4,
		draw_battle: false,
		update: function(update_time) {
			time += update_time;
			var mod_flash = time % flash_cycle_time;
			blackout_alpha = mod_flash < (flash_cycle_time / 2) ? 0.5 : 0;
			if (time >= (flash_cycle_time * number_of_flash_cycles) - 1) {
				blackout_alpha = 0;
				update = fade_to_black;
			}
		},
		fade_to_black: function(update_time) {
			blackout_alpha += 0.012 * ms_to_frame_mod(update_time);
			if (blackout_alpha >= 1) {
				blackout_alpha = 1;
				draw_battle = true;
				update = fade_from_black;
			}
		},
		fade_from_black: function(update_time) {
			blackout_alpha -= 0.012 * ms_to_frame_mod(update_time);
			if (blackout_alpha <= 0) {
				global.updateable = battle_updateable;
			}
		},
		draw: function(update_time) {
			if (!draw_battle) world_draw(update_time);
		},
		draw_gui: function(update_time) {
			if (draw_battle) battle_updateable.draw_gui(update_time);
			if (blackout_alpha > 0) {
				draw_set_color(c_black);
				draw_set_alpha(blackout_alpha);
				draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
			}
		}
	};
}
