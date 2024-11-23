function Battle() constructor {
	enemies = [];
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
	static draw_enemies = function() {
		var total_width = 0;
		var enemy_gap = 10; // number of pixels
		var enemy_count = array_length(enemies);
		if (enemy_count > 1) {
			total_width += (enemy_count - 1) * enemy_gap;
		}
		for (var i = 0; i < enemy_count; i++) {
			total_width += enemies[i].get_width();
		}
		var draw_x = (display_get_gui_width() / 2) - (total_width / 2);
		var draw_y = display_get_gui_height() / 2;
		for (var i = 0; i < enemy_count; i++) {
			// add half width before and after draw because enemy sprite origins are middle-center
			draw_x += enemies[0].get_width() /2 ;
			enemies[i].draw(draw_x, draw_y);
			draw_x += enemies[i].get_width() / 2;
			draw_x += enemy_gap;
		}
	};
	static draw_gui = function() {
		draw_background();
		draw_enemies();
		draw_blackout();
	};
}

function battle_start(get_intro_animation=battle_get_intro_default) {
	global.updateable = get_intro_animation(new Battle());
}

function battle_enemy_add(battle, enemy) {
	array_push(battle.enemies, enemy);
}
