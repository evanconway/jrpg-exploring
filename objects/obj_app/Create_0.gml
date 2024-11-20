res = {
	width: 320,
	height: 180,
};
scale = 5;
window_set_size(res.width * scale, res.height * scale);
surface_resize(application_surface, res.width * scale, res.height * scale);
window_center();
room_goto(rm_start);

global.updateable = global.world;

updateable = global.updateable;
