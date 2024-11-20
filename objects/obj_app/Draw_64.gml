if (is_struct(updateable) && variable_struct_exists(updateable, "draw_gui")) {
	updateable.draw_gui();
}

if (global.console_open) console_draw();
