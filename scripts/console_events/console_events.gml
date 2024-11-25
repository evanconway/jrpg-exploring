function console_get_options(text) {
	if (text == "") return [];
	var commands = struct_get_names(global.console_events);
	array_sort(commands, true); // "true" means use default ascending algo, this automatically accounts for strings
	return array_filter(commands, method({ text }, function(command) {
		return string_starts_with(command, text);
	}));
}

function console_get_autocomplete(text) {
	var options = console_get_options(text);
	if (array_length(options) == 0) return "";
	/*
	Commands are all in snake case. And we'll organize command concepts by words.
	So auto-complete should return the next word that could be completed from
	the given text. Since options are already sorted, we'll use the first one.
	*/
	var rest_of_first_option = string_delete(options[0], 1, string_length(text));
	
	// we don't need to continue our parsing if there's only 1 viable option
	if (array_length(options) == 1) return rest_of_first_option;
	
	// Search for the next underscore because that's what separates words in this syntax.
	var next_underscore_index = string_pos("_", rest_of_first_option);
	return next_underscore_index == 0 ? rest_of_first_option : string_copy(rest_of_first_option, 1, next_underscore_index);
}

global.console_events = {
	updateable_clear: function() {
		global.updateable = undefined;
	},
	updateable_world: function() {
		global.updateable = global.world;
	},
	battle_start: function() {
		battle_start();
	},
	battle_start_example: function() {
		battle_start();
		battle_enemy_add("Medium Enemy");
		battle_enemy_add("Big Enemy", 100, spr_enemy_big);
		battle_enemy_add("Medium Enemy");
	},
	battle_start_flash: function() {
		battle_start(battle_get_intro_flash_fade);
	},
	battle_enemy_add: function() {
		battle_enemy_add("Medium Enemy");
	},
	battle_enemy_add_big: function() {
		battle_enemy_add("Big Enemy", 100, spr_enemy_big);
	},
	battle_message_test: function() {
		battle_message("The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.");
	},
	battle_attack: function() {
		battle_attack(0, 50);
	},
	battle_attack_choose: function() {
		battle_attack_choose();
	},
};
