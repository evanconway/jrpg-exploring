game_set_speed(60, gamespeed_fps);

res = {
	width: 320,
	height: 180,
};
scale = 3;
window_set_size(res.width * scale, res.height * scale);
surface_resize(application_surface, res.width * scale, res.height * scale);
display_set_gui_size(res.width, res.height);
window_center();
room_goto(rm_start);

global.updateable = global.world;

