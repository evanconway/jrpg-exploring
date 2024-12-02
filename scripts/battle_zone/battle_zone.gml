// time in milliseconds before next battle can start
global.battle_zone_safe_time = 4000;

function battle_zone_reset_safe_time() {
	global.battle_zone_safe_time = random_range(3000, 6000);
}
