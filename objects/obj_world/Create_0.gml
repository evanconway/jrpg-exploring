update = function(update_time) {};
draw = function(update_time) {
	draw_set_alpha(1);
	draw_self();
};

show_debug_message(string(id));

global.world.objects[$ string(id)] = id;
