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
	battle_enemy_add: function() {
		if (instanceof(global.updateable) == "Battle") {
			battle_enemy_add(global.updateable, new BattleEnemy());
		}
	},
	battle_enemy_add_big: function() {
		if (instanceof(global.updateable) == "Battle") {
			battle_enemy_add(global.updateable, new BattleEnemyBig());
		}
	},
};

