var delta_time_milliseconds = 1/60 * 1000; //delta_time / 1000;

if (keyboard_check_pressed(192) || keyboard_check_pressed(50)) {
	global.console_open = !global.console_open;
}

if (global.console_open) {
	console_update();
} else {
	// handle game input
}

if (is_struct(global.updateable) && variable_struct_exists(global.updateable, "update")) {
	global.updateable.update(delta_time_milliseconds);
}

camera_set_view_size(view_camera[0], res.width, res.height);
camera_set_view_pos(view_camera[0], 0, 0);

if (keyboard_check_pressed(vk_anykey)) show_debug_message(keyboard_key);

if (keyboard_check_pressed(ord("F"))) {
	window_set_fullscreen(!window_get_fullscreen());
}