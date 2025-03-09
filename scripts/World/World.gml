global.world = {
	objects: {},
	update: world_update,
	draw: world_draw,
	draw_gui: world_draw_gui,
};

function world_update(update_time) {
	with (obj_battle_zone) {
		catch_player_position();
	}
	with (obj_overworld_enemy) {
		update(update_time);
	}
	with (obj_player) {
		update(update_time);
	}
	with (obj_battle_zone) {
		update(update_time);
	}
}

function world_draw(update_time) {
	var drawn_instances = {};
	
	with (obj_battle_zone) {
		draw(update_time);
		drawn_instances[$ string(id)] = id;
	}
	with (obj_overworld_enemy) {
		draw(update_time);
		drawn_instances[$ string(id)] = id;
	}
	with (obj_player) {
		draw(update_time);
		drawn_instances[$ string(id)] = id;
	}
	
	struct_foreach(global.world.objects, method({ update_time, drawn_instances }, function(k, v) {
		if (struct_exists(drawn_instances, k)) return;
		v.draw(update_time);
	}));
}

function world_draw_gui(update_time) {

}
