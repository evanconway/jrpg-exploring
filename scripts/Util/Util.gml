/**
 * Given the number of milliseconds since the last frame, returns the 
 * percentage of frame time passed as a real between 0 and 1.
 */
function ms_to_frame_mod(time_microseconds=(delta_time / 1000)) {
	return time_microseconds / (1000 / 60);
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
