if (is_struct(global.updateable) && variable_struct_exists(global.updateable, "draw")) {
	global.updateable.draw(delta_time / 1000);
}
