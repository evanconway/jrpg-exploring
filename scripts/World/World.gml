function world_update() {
	with (obj_world) {
		if (variable_instance_exists(id, "update")) update();
	}
}

function world_draw() {
	with (obj_world) {
		if (variable_instance_exists(id, "draw")) draw();
	}
}

function world_draw_gui() {
	with (obj_world) {
		if (variable_instance_exists(id, "draw_gui")) draw_gui();
	}
}

global.world = {
	update: world_update,
	draw: world_draw,
	draw_gui: world_draw_gui,
};
