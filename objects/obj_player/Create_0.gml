event_inherited();

update = function(update_time) {
	var vel_x = 0;
	var vel_y = 0;
	var base_vel = value_cfr(1, update_time);
	if (keyboard_check(vk_left)) vel_x -= base_vel;
	if (keyboard_check(vk_right)) vel_x += base_vel;
	if (keyboard_check(vk_up)) vel_y -= base_vel;
	if (keyboard_check(vk_down)) vel_y += base_vel;
	x += vel_x;
	y += vel_y;
};
