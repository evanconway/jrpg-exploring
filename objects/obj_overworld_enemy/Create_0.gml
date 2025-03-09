event_inherited();

enum OVERWORLD_ENEMY_STATE {
	WAITING,
	MOVING
}

enum OVERWORLD_ENEMY_DIR {
	N,
	S,
	E, 
	W
}

directions = [OVERWORLD_ENEMY_DIR.N, OVERWORLD_ENEMY_DIR.S, OVERWORLD_ENEMY_DIR.E, OVERWORLD_ENEMY_DIR.W];

get_random_dir = function() {
	return directions[floor(random(4))];
};

move_speed = 1;
state = OVERWORLD_ENEMY_STATE.WAITING;
state_time = 60;
move_dir = get_random_dir();

update = function(update_time) {
	if (state_time <= 0 && state == OVERWORLD_ENEMY_STATE.WAITING) {
		state = OVERWORLD_ENEMY_STATE.MOVING;
		move_dir = get_random_dir();
		state_time = irandom_range(10, 45)
	}
	if (state_time <= 0 && state == OVERWORLD_ENEMY_STATE.MOVING) {
		state = OVERWORLD_ENEMY_STATE.WAITING;
		state_time = irandom_range(30, 120)
	}
	if (state == OVERWORLD_ENEMY_STATE.MOVING) {
		if (move_dir == OVERWORLD_ENEMY_DIR.N) {
			y -= move_speed;
		}
		if (move_dir == OVERWORLD_ENEMY_DIR.S) {
			y += move_speed;
		}
		if (move_dir == OVERWORLD_ENEMY_DIR.E) {
			x += move_speed;
		}
		if (move_dir == OVERWORLD_ENEMY_DIR.W) {
			x -= move_speed;
		}
	}
	state_time -= 1;
	
	if (place_meeting(x, y, obj_player)) {
		battle_start(battle_get_intro_flash_fade);
		battle_enemy_add("bug", 40, spr_overworld_enemy);
		battle_on_end(function() {
			instance_destroy(id);
		})
	}
};
