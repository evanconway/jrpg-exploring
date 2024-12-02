function world_update(update_time) {
	obj_battle_zone.catch_player_position();
	obj_player.update(update_time);
	obj_battle_zone.update(update_time);
}

function world_draw(update_time) {
	obj_player.draw();
}

function world_draw_gui(update_time) {

}

global.world = {
	update: world_update,
	draw: world_draw,
	draw_gui: world_draw_gui,
};
