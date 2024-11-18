global.world = {
	update: function() {
		with (obj_world) {
			if (variable_instance_exists(id, "update")) update();
		}
	},
	draw: function() {
		with (obj_world) {
			if (variable_instance_exists(id, "draw")) draw();
		}
	},
	draw_gui: function() {
		with (obj_world) {
			if (variable_instance_exists(id, "draw_gui")) draw_gui();
		}
	},
};
