camera_set_view_size(view_camera[0], res.width, res.height);
camera_set_view_pos(view_camera[0], 0, 0);

if (variable_struct_exists(global.updateable, "update")) {
	global.updateable.update();
}
