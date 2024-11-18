event_inherited();

update = function() {
	var vel_x = 0;
	var vel_y = 0;
	if (keyboard_check(vk_left)) vel_x -= 1;
	if (keyboard_check(vk_right)) vel_x += 1;
	if (keyboard_check(vk_up)) vel_y -= 1;
	if (keyboard_check(vk_down)) vel_y += 1;
	x += vel_x;
	y += vel_y;
};
