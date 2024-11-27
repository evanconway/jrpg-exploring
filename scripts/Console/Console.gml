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
	if ((keyboard_check_pressed(189) || keyboard_check_pressed(109)) && keyboard_check(vk_shift)) global.console_text += "_";
	if (keyboard_check_pressed(vk_backspace) && global.console_text != "") global.console_text = string_copy(global.console_text, 0, string_length(global.console_text) - 1);
	if (keyboard_check_pressed(vk_enter)) {
		var event_function = struct_get(global.console_events, global.console_text);
		if (is_method(event_function)) event_function();
		global.console_text = "";
		// global.console_open = false;
	}
	if (keyboard_check_pressed(vk_tab)) {
		global.console_text += console_get_autocomplete(global.console_text);
	}
}

function console_draw() {
	draw_set_font(fnt_console);
	
	var command = global.console_text;
	
	var padding = 4;
	// draw background
	draw_set_alpha(0.75);
	draw_set_color(c_black);
	draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
	
	draw_set_alpha(1)
	draw_set_color(c_white);
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
	var options = console_get_options(command);
	var draw_y = padding;
	if (command == "") {
		// do nothing
	} else if (array_length(options) == 0) {
		draw_set_color(c_red);
		draw_text(padding, draw_y, "no matches");
	} else {
		for (var i = 0; i < array_length(options); i++) {
			draw_text(padding, draw_y, options[i]);
			draw_y += string_height(options[i]);
		}
	}
	
	// draw text
	draw_set_valign(fa_bottom);
	draw_set_halign(fa_left);
	
	if (command == "") {
		draw_set_color(c_dkgray);
		draw_text(padding, display_get_gui_height() - padding, "type a command");
		return;
	}
	
	var text_color = c_red
	if (array_length(options) > 0) text_color = c_white;
	if (struct_exists(global.console_events, command)) text_color = c_lime;
	draw_set_color(text_color);
	draw_text(padding, display_get_gui_height() - padding, command);
	
	var autocomplete = console_get_autocomplete(command);
	draw_set_color(c_dkgray);
	draw_text(padding + string_width(command), display_get_gui_height() - padding, autocomplete);
}
