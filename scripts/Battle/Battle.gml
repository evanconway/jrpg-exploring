function Battle() constructor {
	enemies = [];
	static update = function() {
		// the real battle update loop, not implemented yet
	};
	draw_background = function () {
		draw_set_color(c_gray);
		draw_set_alpha(1);
		draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
	};
	static draw_enemies = function() {
		/*
		We may want to change this in the future so that enemy location
		is given when the enemies our added. So instead of this function
		determining where enemies are drawn, the logic that added them
		determines it.
		*/
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
			draw_x += enemies[i].get_width() /2 ;
			enemies[i].draw(draw_x, draw_y);
			draw_x += enemies[i].get_width() / 2;
			draw_x += enemy_gap;
		}
	};
	static draw_gui = function() {
		draw_background();
		draw_enemies();
	};
}

/**
 * Use this function when an updateable dealing with battles has completed, and
 * the next step in the battle must be determined. Logic is executed here to 
 * determine what the next updateable should be.
 *
 * @param {Struct.Battle} battle Battle instance to return to.
 */
function battle_return(battle) {
	if (instanceof(battle) != "Battle") {
		show_error("battle_return was given a non-battle argument", true);
	}
	global.updateable = battle;
}

// not finished
function battle_start(get_intro_animation=battle_get_intro_default) {
	global.updateable = get_intro_animation(new Battle());
}

/**
 * Returns true if current global updateable is a battle instance.
 */
function battle_inactive() {
	return instanceof(global.updateable) != "Battle";
}

function battle_draw_tdt(tdt) {
	draw_set_valign(fa_middle);
	draw_set_halign(fa_center);
	draw_set_alpha(1);
	draw_set_color(c_black);
	var rect_height = tag_decorated_text_get_height(tdt) * 1.2;
	draw_rectangle(0, 0, display_get_gui_width(), rect_height, false);
	tag_decorated_text_draw(tdt, display_get_gui_width() / 2, rect_height / 2);
}

function battle_get_message_tdt(text) {
	var width = display_get_gui_width() * 0.8;
	var height = display_get_gui_height() * 0.2;
	var tdt = new TagDecoratedTextDefault(text, "f:fnt_battle t:80,1", width, height);
	tag_decorated_text_reset_typing(tdt);
	return tdt;
}

/**
 * Display the given text as a message during battle.
 *
 * @param {String} text
 */
function battle_message(text) {
	if (battle_inactive()) return;
	global.updateable = {
		battle: global.updateable,
		tdt: battle_get_message_tdt(text),
		update: function() {
			if (!keyboard_check_pressed(vk_space)) return;
			if (tag_decorated_text_get_typing_finished(tdt)) {
				battle_return(battle);
			} else {
				tag_decorated_text_advance(tdt);
			}
		},
		draw_gui: function() {
			battle.draw_gui();
			battle_draw_tdt(tdt);
		},
	}
}

function battle_enemy_add(enemy) {
	if (battle_inactive()) return;
	array_push(global.updateable.enemies, enemy);
}
