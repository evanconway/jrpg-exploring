function console_events(e="") {
	if (e == "updateable_clear") {
		global.updateable = undefined;
	}
	
	if (e == "updateable_world") {
		global.updateable = global.world;
	}
	
	if (e == "battle_start") {
		battle_start();
	}
}
