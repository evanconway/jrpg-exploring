var delta_time_milliseconds = 1/60 * 1000; //delta_time / 1000;

if (is_struct(global.updateable) && variable_struct_exists(global.updateable, "draw_gui")) {
	global.updateable.draw_gui(delta_time_milliseconds);
}

if (global.console_open) console_draw();
