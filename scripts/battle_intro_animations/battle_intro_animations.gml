// All battle intro animations should link to some sort of updateable referencing the battle object.

function battle_get_intro_default() {
	return {
		update: battle_return,
	}
}

function battle_get_intro_flash_fade() {
	return {
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
				battle_return();
			}
		},
		draw: function(update_time) {
			if (!draw_battle) world_draw(update_time);
		},
		draw_gui: function(update_time) {
			if (draw_battle) global.battle.draw_gui(update_time);
			colorout_gui(blackout_alpha);
		}
	};
}
