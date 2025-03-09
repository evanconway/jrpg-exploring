event_inherited();



dir = get_random_dir();
state = 0;
state_time = 1000;
move_speed_max = 0.5;
move_speed = 0;
move_acc = 0.01

move = function(update_time) {
	var change_dist = move_speed * ms_to_frame_mod(update_time);
	if (dir == DIRECTION.UP) {
		y -= change_dist;
	}
	if (dir == DIRECTION.DOWN) {
		y += change_dist;
	}
	if (dir == DIRECTION.LEFT) {
		x -= change_dist;
	}
	if (dir == DIRECTION.RIGHT) {
		x += change_dist;
	}
};

update_dec = function(update_time) {
	move_speed = clamp(move_speed - move_acc, 0, move_speed_max);
	move(update_time);
	if (move_speed <= 0) {
		state_time = irandom_range(1000, 2000);
		movement_update = update_wait;
	}
};

update_move = function(update_time) {
	move(update_time);
	if (state_time <= 0) {
		movement_update = update_dec;
	}
};

update_acc = function(update_time) {
	move_speed = clamp(move_speed + move_acc, 0, move_speed_max);
	move(update_time);
	if (move_speed == move_speed_max) {
		state_time = irandom_range(0, 400);
		movement_update = update_move;
	}
};

update_wait = function(update_time) {
	if (state_time > 0) return;
	dir = get_random_dir();
	movement_update = update_acc;
};

movement_update = update_wait;

update = function(update_time) {
	movement_update(update_time);
	state_time -= (update_time);
	
	if (place_meeting(x, y, obj_player)) {
		battle_start(battle_get_intro_flash_fade);
		battle_enemy_add("bug", 40, spr_overworld_enemy);
		battle_on_end(function() {
			instance_destroy(id);
		})
	}
};

get_face_index = function() {
	if (dir == DIRECTION.UP) return 0;
	if (dir == DIRECTION.DOWN) return 1;
	if (dir == DIRECTION.LEFT) return 2;
	if (dir == DIRECTION.RIGHT) return 3;
	return 0;
};

draw = function() {
	draw_set_alpha(1);
	draw_self();
	draw_sprite(spr_broken_soul_face, get_face_index(), x, y);
};
