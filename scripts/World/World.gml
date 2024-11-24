function world_update(update_time) {
	with (obj_world) {
		if (variable_instance_exists(id, "update")) update(update_time);
	}
}

function world_draw(update_time) {
	with (obj_world) {
		if (variable_instance_exists(id, "draw")) draw(update_time);
	}
}

function world_draw_gui(update_time) {
	with (obj_world) {
		if (variable_instance_exists(id, "draw_gui")) draw_gui(update_time);
	}
}

global.world = {
	update: world_update,
	draw: world_draw,
	draw_gui: world_draw_gui,
};
