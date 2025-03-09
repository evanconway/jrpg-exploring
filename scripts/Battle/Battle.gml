function Battle() constructor {
	enemies = [];
	draw_background = function () {
		colorout_gui(1, c_gray);
	};
	on_end = function() {
		show_debug_message("battle over");
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
	static draw_gui = function(update_time) {
		draw_background();
		draw_enemies();
	};
}

/*
The game will always contain a global reference to a battle. To actually perform a battle, the game will switch
between updateables which reference this instance, modify it, and draw it. Since the instance doesn't do anything
when the active updateable isn't referencing it, we'll probably just create a new one whenever a battle starts
and not bother setting this to undefined.
*/
global.battle = new Battle();

/**
 * Get a new enemy instance for a battle.
 */
function BattleEnemy(enemy_name="Test Enemy", health=100, enemy_sprite=spr_enemy) constructor {
	name = enemy_name;
	static unique_enemy_id = 0;
	enemy_id = unique_enemy_id;
	unique_enemy_id += 1;
	enemy_health = health;
	sprite = enemy_sprite;
	static get_width = function() {
		return sprite_get_width(sprite);
	};
	enemy_alpha = 1; // just used for defeat animation for now
	static draw = function(x, y) {
		draw_set_alpha(enemy_alpha);
		draw_sprite(sprite, 0, x, y);
		draw_set_font(fnt_battle);
		draw_set_valign(fa_middle);
		draw_set_halign(fa_center);
		draw_set_color(c_lime);
		draw_text(x, y, enemy_health);
	};
}

function battle_tdt_get(text) {
	var width = display_get_gui_width() * 0.8;
	var height = display_get_gui_height() * 0.2;
	var tdt = new TagDecoratedTextDefault(text, "f:fnt_battle t:80,1", width, height);
	tag_decorated_text_reset_typing(tdt);
	return tdt;
}

function battle_tdt_update(tdt, update_time, on_complete) {
	tag_decorated_text_update(tdt, update_time);
	if (!keyboard_check_pressed(vk_space)) return;
	if (tag_decorated_text_get_typing_finished(tdt)) {
		on_complete();
	} else {
		tag_decorated_text_advance(tdt);
	}
}

function battle_tdt_draw(tdt, update_time) {
	draw_set_valign(fa_middle);
	draw_set_halign(fa_center);
	draw_set_alpha(1);
	draw_set_color(c_black);
	var rect_height = tag_decorated_text_get_height(tdt) * 1.2;
	draw_rectangle(0, 0, display_get_gui_width(), rect_height, false);
	tag_decorated_text_draw_no_update(tdt, display_get_gui_width() / 2, rect_height / 2);
}

/**
 * Display the given text as a message during battle.
 *
 * @param {String} text
 */
function battle_message(text) {
	global.updateable = {
		tdt: battle_tdt_get(text),
		update: function(update_time) {
			battle_tdt_update(tdt, update_time, method(self, battle_return));
		},
		draw_gui: function(update_time) {
			global.battle.draw_gui(update_time);
			battle_tdt_draw(tdt, update_time);
		},
	}
}

function battle_enemy_add(name="Test Enemy", health=100, enemy_sprite=spr_enemy) {
	var new_enemy = new BattleEnemy(name, health, enemy_sprite);
	array_push(global.battle.enemies, new_enemy);
}

function battle_get_enemy_index_by_id(enemy_id) {
	return array_find_index(global.battle.enemies, method({ enemy_id },function(e) {
		return e.enemy_id == enemy_id;
	}));
}

function battle_enemy_defeat(enemy_index) {
	if (enemy_index < 0) {
		battle_message($"No enemy with id {enemy_id}.");
		return;
	}
	global.updateable = {
		enemy_index,
		tdt: battle_tdt_get($"{global.battle.enemies[enemy_index].name} was defeated!"),
		update: function(update_time) {
			battle_tdt_update(tdt, update_time, method(self, function() {
				global.battle.enemies[enemy_index].enemy_alpha = 0.5
				update = fade_enemy;
			}));
		},
		fade_enemy: function(update_time) {
			global.battle.enemies[enemy_index].enemy_alpha -= frame_value_ms_convert(0.008, update_time);
			if (global.battle.enemies[enemy_index].enemy_alpha <= 0) {
				global.battle.enemies = array_filter(global.battle.enemies, method(self, function(e, i) {
					return i != enemy_index;
				}));
				battle_return();
			}
		}, 
		draw_gui: function(update_time) {
			global.battle.draw_gui(update_time);
			battle_tdt_draw(tdt, update_time);
		},
	};
}

/**
 * Sets the battle to a mode where the player chooses an enemy to attack.
 */
function battle_attack_choose() {
	if (array_length(global.battle.enemies) <= 0) {
		show_error("battle_attack_choose cannot work in a battle with no enemies", true);
	}
	
	var tdt = battle_tdt_get("Which enemy will you attack?");
	tag_decorated_text_type_all_pages(tdt);
	
	enemy_options = array_map(global.battle.enemies, method({}, function(enemy) {
		return new BattleActionOption(enemy.name, method({ enemy }, function() {
			battle_attack(enemy.enemy_id, 30);
		}));
	}));
	
	var option_gap = 10;
	var options_height = enemy_options[0].get_height();
	var options_width = enemy_options[0].get_width();
	
	for (var i = 1; i < array_length(enemy_options); i++) {
		options_width += option_gap;
		options_width += enemy_options[i].get_width();
		options_height = max(options_height, enemy_options[i].get_height());
	}
	
	global.updateable = {
		tdt,
		selected_enemy_index: 0,
		option_gap,
		options_width,
		options_height,
		enemy_options,
		update: function(update_time) {
			if (keyboard_check_pressed(vk_left)) selected_enemy_index -= 1;
			if (keyboard_check_pressed(vk_right)) selected_enemy_index += 1;
			selected_enemy_index = clamp(selected_enemy_index, 0, array_length(enemy_options) - 1);
			for (var i = 0; i < array_length(enemy_options); i++) {
				enemy_options[i].set_highlighted(i == selected_enemy_index);
			}
			if (keyboard_check_pressed(vk_space)) {
				enemy_options[selected_enemy_index].on_select();
			}
		},
		draw_enemy_options: function(update_time) {
			var draw_x = (display_get_gui_width() / 2) - (options_width / 2);
			var draw_y = display_get_gui_height() - ((options_height * 1.2) / 2);
			for (var i = 0; i < array_length(enemy_options); i++) {
				draw_x += (enemy_options[i].get_width() / 2);
				enemy_options[i].draw(draw_x, draw_y);
				draw_x += (enemy_options[i].get_width() / 2);
				draw_x += option_gap;
			}
		},
		draw_gui: function(update_time) {
			global.battle.draw_gui(update_time);
			battle_tdt_draw(tdt, update_time);
			draw_set_alpha(1);
			draw_set_color(c_black);
			draw_rectangle(0, display_get_gui_height(), display_get_gui_width(), display_get_gui_height() - options_height * 1.2, false);
			draw_enemy_options(update_time);
		},
	};
}

function BattleActionOption(text, on_select_callback) constructor {
	tdt = new TagDecoratedTextDefault(text, "f:fnt_battle dkgray");
	tdt_highlight = new TagDecoratedTextDefault(text, "f:fnt_battle white");
	is_highlighted = false;
	static set_highlighted = function(highlighted) {
		is_highlighted = highlighted;
	};
	on_select = on_select_callback;
	static get_width = function() {
		return tag_decorated_text_get_width(tdt);
	};
	static get_height = function() {
		return tag_decorated_text_get_height(tdt);
	};
	static draw = function(x, y, update_time) {
		draw_set_valign(fa_middle);
		draw_set_halign(fa_center);
		draw_set_alpha(1);
		tag_decorated_text_draw(is_highlighted ? tdt_highlight : tdt, x, y, update_time);
	}
}

/**
 * Sets the battle to an action menu where the player can choose options.
 */
function battle_action_menu() {	
	global.updateable = {
		gap: 10, // in pixels
		options: [
			new BattleActionOption("Attack", function() {}),
		],
		draw_gui: function(update_time) {
			global.battle.draw_gui(update_time);
		}
	};
}

/**
 * Use this function when an updateable dealing with battles has completed, and
 * the next step in the battle must be determined. Logic is executed here to 
 * determine what the next updateable should be.
 *
 */
function battle_return() {
	var enemies = global.battle.enemies;
	for (var i = 0; i < array_length(enemies); i++) {
		if (enemies[i].enemy_health <= 0) {
			battle_enemy_defeat(i);
			return;
		}
	}
	if (array_length(global.battle.enemies) > 0) {
		battle_attack_choose();
		return;
	}
	global.updateable = {
		tdt: battle_tdt_get("The battle is over."),
		draw_battle: true,
		blackout_alpha: 0,
		update: function(update_time) {
			battle_tdt_update(tdt, update_time, method(self, function() {
				update = fade_out;
			}));
		},
		fade_out: function(update_time) {
			blackout_alpha += (update_time / 1200);
			if (blackout_alpha >= 1) {
				blackout_alpha = 1;
				draw_battle = false;
				update = fade_back;
			}
		},
		fade_back: function(update_time) {
			blackout_alpha -= (update_time / 1200);
			if (blackout_alpha <= 0) {
				global.updateable = global.world;
				global.battle.on_end();
			}
		},
		draw_gui: function(update_time) {
			if (draw_battle) {
				global.battle.draw_gui(update_time);
				battle_tdt_draw(tdt, update_time);
			} else {
				world_draw(update_time);
			}
			colorout_gui(blackout_alpha);
		},
	};
}

/*
 * Begin a new battle.
 */
function battle_start(get_intro_animation=battle_get_intro_default) {
	global.battle = new Battle();
	global.updateable = get_intro_animation();
}

/**
 * Set the on_end field of the current battle instance.
 */
function battle_on_end(on_end = function() {}) {
	global.battle.on_end = on_end;
}

function battle_attack(enemy_id, damage) {
	var enemy_index = battle_get_enemy_index_by_id(enemy_id);
	if (enemy_index < 0) {
		battle_message($"No enemy with the given enemy_id {enemy_id}!");
		return;
	}
	global.updateable = {
		enemy_index,
		tdt: battle_tdt_get($"You attacked {global.battle.enemies[enemy_index].name}."),
		fade_alpha: 0,
		damage,
		update: function(update_time) {
			battle_tdt_update(tdt, update_time, method(self, function() {
				fade_alpha = 0.7;
				global.battle.enemies[enemy_index].enemy_health -= damage;
				update = attack_animation;
			}));
		},
		attack_animation: function(update_time) {
			fade_alpha -= frame_value_ms_convert(0.015, update_time);
			if (fade_alpha <= 0) {
				fade_alpha = 0;
				battle_message($"Dealt {damage} damage to {global.battle.enemies[enemy_index].name}.");
				update = function(update_time) {};
			}
		},
		draw_gui: function(update_time) {
			global.battle.draw_gui(update_time);
			colorout_gui(fade_alpha, c_white);
			battle_tdt_draw(tdt, update_time);
		},
	};
}
