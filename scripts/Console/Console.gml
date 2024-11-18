global.console_text = "";
global.console_open = false;

function console_update() {
	if (keyboard_check_pressed(ord("A"))) global.console_text += "a";
	if (keyboard_check_pressed(ord("B"))) global.console_text += "b";
	if (keyboard_check_pressed(ord("C"))) global.console_text += "c";
	if (keyboard_check_pressed(ord("D"))) global.console_text += "d";
	if (keyboard_check_pressed(ord("E"))) global.console_text += "e";
	if (keyboard_check_pressed(ord("F"))) global.console_text += "f";
	if (keyboard_check_pressed(ord("G"))) global.console_text += "g";
	if (keyboard_check_pressed(ord("H"))) global.console_text += "h";
	if (keyboard_check_pressed(ord("I"))) global.console_text += "i";
	if (keyboard_check_pressed(ord("J"))) global.console_text += "j";
	if (keyboard_check_pressed(ord("K"))) global.console_text += "k";
	if (keyboard_check_pressed(ord("L"))) global.console_text += "l";
	if (keyboard_check_pressed(ord("M"))) global.console_text += "m";
	if (keyboard_check_pressed(ord("N"))) global.console_text += "n";
	if (keyboard_check_pressed(ord("O"))) global.console_text += "o";
	if (keyboard_check_pressed(ord("P"))) global.console_text += "p";
	if (keyboard_check_pressed(ord("Q"))) global.console_text += "q";
	if (keyboard_check_pressed(ord("R"))) global.console_text += "r";
	if (keyboard_check_pressed(ord("S"))) global.console_text += "s";
	if (keyboard_check_pressed(ord("T"))) global.console_text += "t";
	if (keyboard_check_pressed(ord("U"))) global.console_text += "u";
	if (keyboard_check_pressed(ord("V"))) global.console_text += "v";
	if (keyboard_check_pressed(ord("W"))) global.console_text += "w";
	if (keyboard_check_pressed(ord("X"))) global.console_text += "x";
	if (keyboard_check_pressed(ord("Y"))) global.console_text += "y";
	if (keyboard_check_pressed(ord("Z"))) global.console_text += "z";
	if (keyboard_check_pressed(189) && keyboard_check(vk_shift)) global.console_text += "_";
	if (keyboard_check_pressed(vk_backspace) && global.console_text != "") global.console_text = string_copy(global.console_text, 0, string_length(global.console_text) - 1);
	if (keyboard_check_pressed(vk_enter)) {
		console_events(global.console_text);
		global.console_text = "";
		global.console_open = false;
	}
}

function console_draw() {
	draw_set_alpha(0.3);
	draw_set_color(c_black);
	draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
	draw_set_alpha(1);
	draw_set_color(c_white);
	draw_set_font(fnt_console);
	draw_set_valign(fa_bottom);
	draw_set_halign(fa_left);
	draw_text(4, display_get_gui_height() - 4, global.console_text);
}