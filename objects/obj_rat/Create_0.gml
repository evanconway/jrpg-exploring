event_inherited();

enum RAT_STATE {
	TWITCH,
	RUN
}

move_dir = get_random_dir();

twitch_time = 180;
state_time = twitch_time;
state = RAT_STATE.TWITCH;

image_speed = 0;

update = function(update_time) {
	if (state_time <= 0) {
		image_index = 0;
		image_xscale = 1;
		var state_arr = [RAT_STATE.TWITCH, RAT_STATE.RUN];
		var random_index = irandom_range(0, array_length(state_arr) - 1);
		state = state_arr[random_index];
		if (state == RAT_STATE.TWITCH) {
			state_time = twitch_time;
			if (random(2) > 1) image_xscale = -1;
			sprite_index = spr_rat_idle;
		}
		if (state == RAT_STATE.RUN) {
			state_time = irandom_range(30, 120);
			move_dir = get_random_dir();
			if (move_dir == DIRECTION.UP) {
				sprite_index = spr_rat_move_n;
			}
			if (move_dir == DIRECTION.DOWN) {
				sprite_index = spr_rat_move_s;
			}
			if (move_dir == DIRECTION.LEFT) {
				sprite_index = spr_rat_move_h;
				image_xscale = -1;
			}
			if (move_dir == DIRECTION.RIGHT) {
				sprite_index = spr_rat_move_h;
			}
		}
	}
	
	if (state == RAT_STATE.RUN) {
		var move_dist = value_cfr(1, update_time);
		if (move_dir == DIRECTION.UP) {
			y -= move_dist;
		}
		if (move_dir == DIRECTION.DOWN) {
			y += move_dist;
		}
		if (move_dir == DIRECTION.LEFT) {
			x -= move_dist;
		}
		if (move_dir == DIRECTION.RIGHT) {
			x += move_dist;
		}
		image_index += value_cfr(0.1, update_time);
	}
	if (state == RAT_STATE.TWITCH) {
		image_index = 0;
		if (state_time < 110 && state_time > 100) {
			image_index = 1;
		}
		if (state_time < 85 && state_time > 75) {
			image_index = 1;
		}
	}
	
	state_time -= value_cfr(1, update_time);
};
