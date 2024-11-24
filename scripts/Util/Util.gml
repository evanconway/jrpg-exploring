/**
 * Given the number of milliseconds since the last frame, returns the 
 * percentage of frame time passed as a real between 0 and 1.
 */
function ms_to_frame_mod(time_microseconds=(delta_time / 1000)) {
	return time_microseconds / (1000 / 60);
}
