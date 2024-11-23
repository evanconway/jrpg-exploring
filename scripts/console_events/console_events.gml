function console_events(e="") {
	if (e == "updateable_clear") {
		global.updateable = undefined;
		return;
	}
	if (e == "updateable_world") {
		global.updateable = global.world;
		return;
	}
	if (e == "battle_start") {
		battle_start();
		return;
	}
	if (e == "battle_enemy_add") {
		if (instanceof(global.updateable) == "Battle") {
			battle_enemy_add(global.updateable, new BattleEnemy());
		}
	}
}
