event_inherited();

image_speed = 0;

dir = get_random_dir();
state = 0;
state_time = 1000;
move_speed_max = 0.4;
move_speed = 0;
move_acc = 0.01;

after_images = [];
after_image_alpha_diff = 0.25;
after_image_fade_rate = 0.03;

move = function(update_time) {
	var change_dist = value_cfr(move_speed, update_time);
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

battle_intro = function() {
	return {
		alpha: 1,
		colorout_color: c_white,
		draw_battle: false,
		draw_face: false,
		update: function(update_time) {
			alpha -= value_cfr(0.02, update_time);
			if (alpha <= 0) {
				alpha = 0;
				update = fade_to_black;
				colorout_color = c_black;
			}
		},
		fade_to_black: function(update_time) {
			alpha += value_cfr(0.012, update_time);
			if (alpha >= 1) {
				alpha = 0;
				draw_battle = true;
				update = fade_in_face;
				draw_face = true;
			}
		},
		fade_in_face: function(update_time) {
			alpha += value_cfr(0.01, update_time);
			if (alpha >= 1) {
				global.battle.draw_enemies_active = true;
				battle_message("A Broken Soul appears before you.");
			}
		},
		draw: function(update_time) {
			if (!draw_battle) world_draw(0);
		},
		draw_gui: function(update_time) {
			if (draw_battle) {
				battle_draw(update_time)
			}
			if (draw_face) {
				draw_sprite_ext(
					spr_broken_soul_battle_face,
					0,
					display_get_gui_width() / 2,
					display_get_gui_height() / 2,
					1,
					1,
					0,
					c_white,
					alpha
				);
			} else {
				colorout_gui(alpha, colorout_color);
			}
		}
	};
};

update = function(update_time) {
	movement_update(update_time);
	state_time -= (update_time);
	
	if (place_meeting(x, y, obj_player)) {
		battle_start(battle_intro);
		battle_enemy_add("Broken Soul", 40, spr_broken_soul_battle_face);
		global.battle.draw_enemies_active = false;
		battle_set_draw_background(function() {
			colorout_gui(1, c_black);
		});
		battle_set_on_end(function() {
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

draw_after_images = function() {
	after_images = array_filter(after_images, function(img) {
		return img.alpha > 0;
	});
	
	if (array_length(after_images) <= 0 || (1 - after_images[0].alpha >= after_image_alpha_diff)) {
		array_insert(after_images, 0, { alpha: 1, index: image_index, x, y });
	}
	
	array_foreach(after_images, function(img) {
		draw_sprite_ext(spr_broken_soul_body, img.index, img.x, img.y, 1, 1, 0, c_white, img.alpha);
		img.alpha -= after_image_fade_rate;
	});
};

flames = [];
flame_decay_rate = 0.02;
flame_rise_rate = 0.05;
flame_count = 30;
add_flame = function() {
	var top = sprite_get_bbox_top(sprite_index);
	array_push(flames, {
		x_on_create: x,
		y_on_create: y,
		index: irandom_range(0, image_number),
		x: x + irandom_range(sprite_get_bbox_left(sprite_index), sprite_get_bbox_right(sprite_index)),
		y: y + top + irandom_range(-3, 3),
		alpha: random_range(1, 3),
	});
};

// get count of flames that are still close to body, ignore far away flames
get_flame_count = function() {
	var result = 0;
	for (var i = 0; i < array_length(flames); i++) {
		var f = flames[i];
		if (point_distance(x, y, f.x_on_create, f.y_on_create) <= 5) {
			result += 1;
		}
	}
	return result;
};

while (array_length(flames) < flame_count) {
	add_flame();
}

draw_flames = function(update_time) {
	while (get_flame_count() < flame_count) {
		add_flame();
	}
	
	array_foreach(flames, method({ flame_decay_rate, flame_rise_rate, update_time }, function(f) {
		draw_sprite_ext(spr_broken_soul_flame, f.index, f.x, f.y, 1, 1, 0, c_white, f.alpha);
		f.alpha -= value_cfr(flame_decay_rate, update_time);
		f.y -= value_cfr(flame_rise_rate, update_time);
	}))
	
	flames = array_filter(flames, function(f) {
		return f.alpha > 0;
	});
};

draw = function(update_time) {	
	draw_flames(update_time);
	image_index += value_cfr(0.05, update_time)
	draw_set_alpha(1);
	draw_self();
	draw_sprite(spr_broken_soul_face, get_face_index(), x, y);
};
