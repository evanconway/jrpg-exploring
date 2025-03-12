event_inherited();

enum RAT_STATE {
	TWITCH,
	RUN
}

move_dir = get_random_dir();
twitch_right = true; // d

twitch_time = 180;
state_time = twitch_time;

update = function(update_time) {
	state_time -= value_cfr(1, update_time);
};
