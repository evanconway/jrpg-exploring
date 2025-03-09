event_inherited();

dir = get_random_dir();
state = 0;
state_time = 60;
move_speed = 1;

update = function(update_time) {
	if (state_time <= 0 && state == 0) {
		state = 1;
		dir = get_random_dir();
		state_time = irandom_range(10, 30)
	}
	if (state_time <= 0 && state == 1) {
		state = 0;
		state_time = irandom_range(30, 120)
	}
	if (state == 1) {
		var dist_change = move_speed * ms_to_frame_mod(update_time);
		if (dir == DIRECTION.UP) {
			y -= dist_change;
		}
		if (dir == DIRECTION.DOWN) {
			y += dist_change;
		}
		if (dir == DIRECTION.LEFT) {
			x -= dist_change;
		}
		if (dir == DIRECTION.RIGHT) {
			x += dist_change;
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
