function Battle() constructor {
	enemies = [];
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
	static draw_gui = function(update_time) {
		draw_background();
		draw_enemies();
	};
}

function is_battle(battle) {
	return instanceof(battle) == "Battle";
}

/**
 * Returns true if current global updateable is a battle instance.
 */
function battle_inactive() {
	return !is_battle(global.updateable);
}

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
 * @param {Struct.Battle} battle
 * @param {String} text
 */
function battle_message(battle, text) {
	global.updateable = {
		battle,
		tdt: battle_tdt_get(text),
		update: function(update_time) {
			battle_tdt_update(tdt, update_time, method(self, function() {
				battle_return(battle);
			}));
		},
		draw_gui: function(update_time) {
			battle.draw_gui(update_time);
			battle_tdt_draw(tdt, update_time);
		},
	}
}

function battle_enemy_add(battle, name="Test Enemy", health=100, enemy_sprite=spr_enemy) {
	var new_enemy = new BattleEnemy(name, health, enemy_sprite);
	array_push(battle.enemies, new_enemy);
}

function battle_get_enemy_index_by_id(battle, enemy_id) {
	return array_find_index(battle.enemies, method({ enemy_id },function(e) {
		return e.enemy_id == enemy_id;
	}));
}

function battle_enemy_defeat(battle, enemy_index) {
	if (enemy_index < 0) {
		battle_message(battle, $"No enemy with id {enemy_id}.");
		return;
	}
	global.updateable = {
		battle,
		enemy_index,
		tdt: battle_tdt_get($"{battle.enemies[enemy_index].name} was defeated!"),
		update: function(update_time) {
			battle_tdt_update(tdt, update_time, method(self, function() {
				update = fade_enemy;
			}));
		},
		fade_enemy: function(update_time) {
			battle.enemies[enemy_index].enemy_alpha -= 0.015 * ms_to_frame_mod(update_time);
			if (battle.enemies[enemy_index].enemy_alpha <= 0) {
				battle.enemies = array_filter(battle.enemies, method(self, function(e, i) {
					return i != enemy_index;
				}));
				battle_return(battle);
			}
		}, 
		draw_gui: function(update_time) {
			battle.draw_gui(update_time);
			battle_tdt_draw(tdt, update_time);
		},
	};
}

/**
 * Sets the battle in a mode where the player chooses an enemy to attack.
 */
function battle_attack_choose(battle) {
	if (!is_battle(battle)) {
		show_error("battle_attack_choose was given a non-battle argument", true);
	}
	if (array_length(battle.enemies) <= 0) {
		show_error("battle_attack_choose cannot work in a battle with no enemies", true);
	}
	
	var tdt = battle_tdt_get("Which enemy will you attack?");
	tag_decorated_text_type_all_pages(tdt);
	
	enemy_options = array_map(battle.enemies, method({ battle }, function(enemy) {
		return new BattleActionOption(enemy.name, method({ battle, enemy }, function() {
			battle_attack(battle, enemy.enemy_id, 30);
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
		battle,
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
			battle.draw_gui(update_time);
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
 * Sets the given battle to an action menu where the player can choose options.
 *
 * @param {Struct.Battle} battle Battle instance to return to.
 */
function battle_action_menu(battle) {
	if (!is_battle(battle)) {
		show_error("battle_action_menu was given a non-battle argument", true);
	}
	
	global.updateable = {
		battle,
		gap: 10, // in pixels
		options: [
			new BattleActionOption("Attack", function() {}),
		],
		draw_gui: function(update_time) {
		}
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
	if (!is_battle(battle)) {
		show_error("battle_return was given a non-battle argument", true);
	}
	var enemies = battle.enemies;
	for (var i = 0; i < array_length(enemies); i++) {
		if (enemies[i].enemy_health <= 0) {
			battle_enemy_defeat(battle, i);
			return;
		}
	}
	if (array_length(battle.enemies) > 0) {
		battle_attack_choose(battle);
		return;
	}
	global.updateable = battle;
}

/*
 * Begin a new battle.
 */
function battle_start(get_intro_animation=battle_get_intro_default) {
	global.updateable = get_intro_animation(new Battle());
}

function battle_attack(battle, enemy_id, damage) {
	var enemy_index = battle_get_enemy_index_by_id(battle, enemy_id);
	if (enemy_index < 0) {
		battle_message(battle, $"No enemy with the given enemy_id {enemy_id}!");
		return;
	}
	global.updateable = {
		battle,
		enemy_index,
		tdt: battle_tdt_get($"You attacked {battle.enemies[enemy_index].name}."),
		fade_alpha: 0,
		damage,
		update: function(update_time) {
			battle_tdt_update(tdt, update_time, method(self, function() {
				fade_alpha = 0.7;
				battle.enemies[enemy_index].enemy_health -= damage;
				update = attack_animation;
			}));
		},
		attack_animation: function(update_time) {
			fade_alpha -= 0.015 * ms_to_frame_mod(update_time);
			if (fade_alpha <= 0) {
				fade_alpha = 0;
				battle_message(battle, $"Dealt {damage} damage to {battle.enemies[enemy_index].name}.");
				update = post_attack_message;
			}
		},
		post_attack_message: function(update_time) {},
		draw_gui: function(update_time) {
			battle.draw_gui(update_time);
			if (fade_alpha > 0) {
				draw_set_color(c_white);
				draw_set_alpha(fade_alpha);
				draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
			}
			battle_tdt_draw(tdt, update_time);
		},
	};
}
