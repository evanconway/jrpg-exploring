start_chance = 0.01;
player_position = { x: 0, y: 0 };
battle_start_animation = battle_get_intro_flash_fade;
battle_start_actions = function() {
	battle_enemy_add("Medium Enemy");
};

catch_player_position = function() {
	if (!instance_exists(obj_player)) return;
	player_position.x = obj_player.x;
	player_position.y = obj_player.y;
};

update = function(update_time) {
	if (!instance_exists(obj_player)) return;
	if (!place_meeting(x, y, obj_player)) return;
	if (global.battle_zone_safe_time > 0) {
		global.battle_zone_safe_time -= update_time;
		return;
	}
	
	var diff_x = player_position.x - obj_player.x;
	var diff_y = player_position.y - obj_player.y;
	var player_moved = diff_x != 0 || diff_y != 0;
	
	var battle_roll = random(1);
	if (player_moved && battle_roll < start_chance) {
		battle_zone_reset_safe_time();
		battle_start(battle_start_animation);
		battle_start_actions();
	}
};

draw = function(update_time) {
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, c_white, 0.4);
}
