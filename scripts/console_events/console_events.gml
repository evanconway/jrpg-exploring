function console_get_options(text) {
	if (text == "") return [];
	var commands = struct_get_names(global.console_events);
	array_sort(commands, true); // "true" is default ascending for strings
	return array_filter(commands, method({ text }, function(command) {
		return string_starts_with(command, text);
	}));
}

function console_get_autocomplete(text) {
	var options = console_get_options(text);
	if (array_length(options) == 0) return "";
	
	// for now, we'll just auto_complete the first viable option
	// we can just cut by length because we know options start with the given text
	return string_delete(options[0], 1, string_length(text));
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

