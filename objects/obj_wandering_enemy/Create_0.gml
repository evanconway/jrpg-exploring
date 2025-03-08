enum WANDERING_ENEMY_STATE {
	WAITING,
	MOVING
}

enum WANDERING_ENEMY_DIR {
	N,
	S,
	E, 
	W
}

directions = [WANDERING_ENEMY_DIR.N, WANDERING_ENEMY_DIR.S, WANDERING_ENEMY_DIR.E, WANDERING_ENEMY_DIR.W];

get_random_dir = function() {
	return directions[floor(random(4))];
};

move_speed = 1;
state = WANDERING_ENEMY_STATE.WAITING;
state_time = 60;
move_dir = get_random_dir();

update = function(update_time) {
	if (state_time <= 0 && state == WANDERING_ENEMY_STATE.WAITING) {
		state = WANDERING_ENEMY_STATE.MOVING;
		move_dir = get_random_dir();
		state_time = irandom_range(10, 45)
	}
	if (state_time <= 0 && state == WANDERING_ENEMY_STATE.MOVING) {
		state = WANDERING_ENEMY_STATE.WAITING;
		state_time = irandom_range(30, 120)
	}
	if (state == WANDERING_ENEMY_STATE.MOVING) {
		if (move_dir == WANDERING_ENEMY_DIR.N) {
			y -= move_speed;
		}
		if (move_dir == WANDERING_ENEMY_DIR.S) {
			y += move_speed;
		}
		if (move_dir == WANDERING_ENEMY_DIR.E) {
			x += move_speed;
		}
		if (move_dir == WANDERING_ENEMY_DIR.W) {
			x -= move_speed;
		}
	}
	state_time -= 1;
};

draw = function(update_time) {
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, c_white, 0.4);
}