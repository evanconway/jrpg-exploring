enum DIRECTION {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

function get_random_dir() {
	var dirs = [DIRECTION.UP, DIRECTION.DOWN, DIRECTION.LEFT, DIRECTION.RIGHT];
	return dirs[random(floor(array_length(dirs)))];
}

/**
 * Given a number value and frame time in milliseconds, return that value 
 * adjusted for the given frame rate. For example, at 60fps if a value of
 * 1 and a time of 14 milliseconds is given: the returned value will be 
 * 0.84.
 *
 * @param {real} value the number value to convert
 * @param {real} time time in milliseconds
 */
function frame_value_ms_convert(value, time) {
	var frame_mod = time / (1000 / game_get_speed(gamespeed_fps));
	return value * frame_mod;
}

/**
 * Colors entire screen. Default color is black.
 *
 * @param {real} alpha
 * @param {Constant.Color} colorout_color
 */
function colorout_gui(alpha=1, colorout_color=c_black) {
	if (alpha <= 0) return;
	draw_set_alpha(alpha);
	draw_set_color(colorout_color);
	draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
}
