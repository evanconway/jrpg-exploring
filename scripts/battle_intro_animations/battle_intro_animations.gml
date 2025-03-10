// All battle intro animations should link to some sort of updateable referencing the battle object.

function battle_get_intro_default() {
	return {
		update: battle_return,
	}
}

function battle_get_intro_flicker_fade() {
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
			blackout_alpha += value_cfr(0.012, update_time);
			if (blackout_alpha >= 1) {
				blackout_alpha = 1;
				draw_battle = true;
				update = fade_from_black;
			}
		},
		fade_from_black: function(update_time) {
			blackout_alpha -= value_cfr(0.012, update_time);
			if (blackout_alpha <= 0) {
				battle_return();
			}
		},
		draw: function(update_time) {
			if (!draw_battle) world_draw(0);
		},
		draw_gui: function(update_time) {
			if (draw_battle) global.battle.draw_gui(update_time);
			colorout_gui(blackout_alpha);
		}
	};
}

function battle_get_intro_flash_fade() {
	return {
		time: 0,
		alpha: 1,
		colorout_color: c_white,
		draw_battle: false,
		update: function(update_time) {
			alpha -= value_cfr(0.02, update_time);
			if (alpha <= 0) {
				update = fade_to_black;
				colorout_color = c_black;
			}
		},
		fade_to_black: function(update_time) {
			alpha += value_cfr(0.012, update_time);
			if (alpha >= 1) {
				alpha = 1;
				draw_battle = true;
				update = fade_from_black;
			}
		},
		fade_from_black: function(update_time) {
			alpha -= value_cfr(0.012, update_time);
			if (alpha <= 0) {
				battle_return();
			}
		},
		draw: function(update_time) {
			if (!draw_battle) world_draw(0);
		},
		draw_gui: function(update_time) {
			if (draw_battle) global.battle.draw_gui(update_time);
			colorout_gui(alpha, colorout_color);
		}
	};
}