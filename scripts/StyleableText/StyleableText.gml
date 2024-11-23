// feather ignore all

//// @ignore
function TextStyle() constructor {
	/// @ignore
	font = fnt_styleable_text_font_default;
	/// @ignore
	color = c_white;
	/// @ignore
	alpha = 1;
	/// @ignore
	scale_x = 1;
	/// @ignore
	scale_y = 1;
	/// @ignore
	offset_x = 0;
	/// @ignore
	offset_y = 0;
	/// @ignore
	sprite = spr_styleable_text_sprite_default;
	/// @ignore
	new_line = false; // forces new line start
	
	// SDF effects
	
	outline_distance = 1;
	outline_color = c_green;
	outline_alpha = 0;

	glow_start = 0;
	glow_end = 2;
	glow_color = c_red;
	glow_alpha = 0;
	
	drop_shadow_softness = 8;
	drop_shadow_offsetX = 4;
	drop_shadow_offsetY = 4;
	drop_shadow_color = c_gray;
	drop_shadow_alpha = 0;
	
	/**
	 * Get boolean indicating if the given style is equal to this one.
	 *
	 * @param {struct.TextStyle} style style
	 * @ignore
	 */
	is_equal = function(style) {
		if (style.sprite != spr_styleable_text_sprite_default) return false;
		if (style.new_line) return false;
		if (sprite != spr_styleable_text_sprite_default) return false;
		if (new_line) return false;
		if (style.font != font) return false;
		if (style.color != color) return false;
		if (style.alpha != alpha) return false;
		if (style.scale_x != scale_x) return false;
		if (style.scale_y != scale_y) return false;
		if (style.offset_x != offset_x) return false;
		if (style.offset_y != offset_y) return false;
		if (style.outline_distance != outline_distance) return false;
		if (style.outline_color != outline_color) return false;
		if (style.outline_alpha != outline_alpha) return false;
		if (style.glow_start != glow_start) return false;
		if (style.glow_end != glow_end) return false;
		if (style.glow_color != glow_color) return false;
		if (style.glow_alpha != glow_alpha) return false;
		if (style.drop_shadow_softness != drop_shadow_softness) return false;
		if (style.drop_shadow_offsetX != drop_shadow_offsetX) return false;
		if (style.drop_shadow_offsetY != drop_shadow_offsetY) return false;
		if (style.drop_shadow_color != drop_shadow_color) return false;
		if (style.drop_shadow_alpha != drop_shadow_alpha) return false;
		
		return true;
	};
	
	/// @ignore
	set_to = function(style) {
		font = style.font;
		color = style.color;
		alpha = style.alpha;
		scale_x = style.scale_x;
		scale_y = style.scale_y;
		offset_x = style.offset_x;
		offset_y = style.offset_y;
		sprite = style.sprite;
		new_line = style.new_line;
		outline_distance = style.outline_distance;
		outline_color = style.outline_color;
		outline_alpha = style.outline_alpha;
		glow_start = style.glow_start;
		glow_end = style.glow_end;
		glow_color = style.glow_color;
		glow_alpha = style.glow_alpha;
		drop_shadow_softness = style.drop_shadow_softness;
		drop_shadow_offsetX = style.drop_shadow_offsetX;
		drop_shadow_offsetY = style.drop_shadow_offsetY;
		drop_shadow_color = style.drop_shadow_color;
		drop_shadow_alpha = style.drop_shadow_alpha;
	};
	
	/**
	 * Get a copy of this style.
	 *
	 * @ignore
	 */
	get_copy = function() {
		var copy = new TextStyle();
		copy.set_to(self);
		return copy;
	};
};

/**
 * Creates a new styleable text instance.
 *
 * @param {string} text
 * @ignore
 */
function __TagDecoratedTextStyleable(text, width=-1, height=-1) constructor {
	/// @ignore
	character_array = [];
	/// @ignore
	text_width = width;
	/// @ignore
	text_height = height;
	/// @ignore
	text_line_widths = []; // mapping of line indexes to line widths excluding trailing spaces
	/// @ignore
	text_line_heights = [];
	/// @ignore
	text_page_index = 0;
	/// @ignore
	text_page_index_max = 0;
	/// @ignore
	text_page_widths = [];
	/// @ignore
	text_page_heights = [];
	/// @ignore
	text_page_char_index_start = [];
	/// @ignore
	text_page_char_index_end = [];
	/// @ignore
	widest_page = -1; // used to calculate text width if not specified
	/// @ignore
	highest_page = -1; // use to calculate text height if not specified
	/// @ignore
	debug = false;
	
	// create char array
	var text_length = string_length(text);
	for (var i = 1; i <= text_length; i++) {
		array_push(character_array, {
			char: string_char_at(text, i),
			style: new TextStyle(),
			x: 0,
			y: 0,
			line_index: 0,
			page_index: 0,
			drawable: {
				index_start: i - 1,
				index_end: i - 1,
				text: string_char_at(text, i),
				style: new TextStyle(),
			}
		});
	}
	/// @ignore
	character_array_length = array_length(character_array);
	
	/**
	 * @return {real}
	 */
	static get_char_width = function(char) {
		if (char.style.sprite != spr_styleable_text_sprite_default) return sprite_get_width(char.style.sprite) * char.style.scale_x;
		draw_set_font(char.style.font);
		return string_width(char.char) * char.style.scale_x;
	};
	
	/**
	 * @return {real}
	 */
	static get_char_height = function(char) {
		if (char.style.sprite != spr_styleable_text_sprite_default) return sprite_get_height(char.style.sprite) * char.style.scale_y;
		draw_set_font(char.style.font);
		return string_height(char.char) * char.style.scale_y;
	};
	
	/// @ignore
	calculate_char_positions = function() {
		text_line_widths = [];
		text_line_heights = [];
		var word_i_start = 0;
		var word_i_end = 0;	// inclusive
		var word_width = 0;	// width of letter chars, excludes trailing spaces
		var char_max_height = 0;
		var char_x = 0;
		var line_index = 0;
		var word_complete = false; // space encountered
		
		// determine line breaks and x position
		for (var i = 0; i <= character_array_length; i++) {
			var add_word_to_line = false;
		
			// reset drawable
			if (i < character_array_length) {
				character_array[i].drawable = {
					index_start: i,
					index_end: i,
					text: character_array[i].char,
					style: character_array[i].style.get_copy(),
				};
			}
		
			var force_new_line = i < character_array_length && character_array[i].style.new_line;
		
			if (force_new_line) {
				add_word_to_line = true;
			} else if (i >= character_array_length) {
				add_word_to_line = true; // always add when done with array
			} else if (character_array[i].char == " ") {
				word_complete = true;
				word_i_end = i;
			} else if (!word_complete) {
				word_width += get_char_width(character_array[i]);
				word_i_end = i;
			} else {
				add_word_to_line = true;
			}

			if (add_word_to_line && text_width >= 0 && char_x + word_width >= text_width) {
				line_index += char_x > 0 ? 1 : 0;
				char_x = 0;
				char_max_height = 0;
			}
		
			if (add_word_to_line) {
				for (var w = word_i_start; w <= word_i_end; w++) {
					character_array[w].x = char_x;
					character_array[w].line_index = line_index;
					char_x += get_char_width(character_array[w]);
					var char_height = get_char_height(character_array[w]);
					if (char_height > char_max_height) char_max_height = char_height;
					text_line_heights[line_index] = char_max_height;
				}
				word_i_start = i;
				word_i_end = i;
				word_width = i < character_array_length ? get_char_width(character_array[i]) : 0;
				word_complete = false;
				if (force_new_line) {
					line_index += char_x > 0 ? 1 : 0;
					char_x = 0;
					char_max_height = 0;
				}
			}
		}
		
		// determine y position and page index of line indexes
		var page_height = text_line_heights[0];
		text_page_index_max = 0;
		var line_index_y_pos_map = [];
		var line_index_page_index_map = [];
		line_index_y_pos_map[0] =  0;
		line_index_page_index_map[0] = text_page_index_max;
		
		for (var i = 1; i < array_length(text_line_heights); i++) {
			var line_height = text_line_heights[i];
			if (text_height >= 0 && line_height + page_height > text_height) {
				text_page_index_max++;
				page_height = 0;
			}
			line_index_y_pos_map[i] = page_height;
			line_index_page_index_map[i] = text_page_index_max;
			page_height += line_height;
		}
		
		// ensure line widths has default value for each index
		for (var i = 0; i < array_length(text_line_heights); i++) {
			text_line_widths[i] = 0;
		}
		
		// assign page indexes, y positions and determine line widths
		var space_width = 0;
		var li_prev = 0;
		
		text_page_widths = [];
		text_page_heights = [];
		
		var line_heights_added_to_page = []; // used to track if a line height has been accounted for in page heights
		
		for (var i = 0; i < character_array_length; i++) {
			var char = character_array[i];
			if (char.line_index != li_prev) {
				li_prev = char.line_index;
				space_width = 0;
			}
			if (char.char == " ") space_width += get_char_width(char);
			else {
				var line_width = text_line_widths[char.line_index];
				text_line_widths[char.line_index] = line_width + get_char_width(char) + space_width;
				space_width = 0;
			}
			char.y = line_index_y_pos_map[char.line_index];
			char.page_index = line_index_page_index_map[char.line_index];
			
			// set page start and ends
			if (char.page_index >= array_length(text_page_char_index_start)) text_page_char_index_start[char.page_index] = i;
			if (i == character_array_length - 1) {
				text_page_char_index_end[char.page_index] = i;
			}
			if (i > 0 && char.page_index != character_array[i - 1].page_index) {
				text_page_char_index_end[character_array[i - 1].page_index] = i - 1;
			}
			
			// page dimensions
			if (char.page_index >= array_length(text_page_widths)) {
				text_page_widths[char.page_index] = text_line_widths[char.line_index];
			}
			text_page_widths[char.page_index] = max(text_page_widths[char.page_index], text_line_widths[char.line_index]);
			if (char.line_index >= array_length(line_heights_added_to_page)) {
				line_heights_added_to_page[char.line_index] = false;
			}
			if (!line_heights_added_to_page[char.line_index]) {
				if (char.page_index >= array_length(text_page_heights)) {
					text_page_heights[char.page_index] = 0;
				}
				text_page_heights[char.page_index] += text_line_heights[char.line_index];
				line_heights_added_to_page[char.line_index] = true;
			}
		}
		
		for (var i = 0; i <= text_page_index_max; i++) {
			if (text_page_widths[i] > widest_page) widest_page = text_page_widths[i];
			if (text_page_heights[i] > highest_page) highest_page = text_page_heights[i];
		}
	};
	/// @ignore
	get_width = function() {
		return max(widest_page, text_width);
	};
	/// @ignore
	get_height = function() {
		return max(highest_page, text_height);
	}
	
	/**
	 * This function is used to determine if drawables can be merged. returns false if there are any
	 * qualities about the 2 chars at the indexes given that would prevent their drawables from
	 * being merged. Drawables cannot be merged if the drawable styles differ, or if the underlying
	 * styles of the base characters differ.
	 */
	/// @ignore
	char_drawables_mergeable = function(index_a, index_b) {
		var char_a = character_array[index_a];
		var char_b = character_array[index_b];
		if (char_a.drawable.index_end + 1 != char_b.drawable.index_start) return false;
		if (!char_a.drawable.style.is_equal(char_b.drawable.style)) return false;
		if (!char_a.style.is_equal(char_b.style)) return false;
		if (char_a.y != char_b.y) return false;
		if (char_a.line_index != char_b.line_index) return false;
		return true;
	};
	
	/**
	 * Should probably replace merge_all_drawables with this function, but called on the entire system
	 *
	 * @param {real} index_start first index to merge at
	 * @param {real} index_end last index to merge at, inclusive
	 * @ignore
	 */
	merge_drawables_at_index_range = function(index_start, index_end) {
		var index = index_start == 0 ? 0 : index_start - 1;
		while (index <= index_end && character_array[index].drawable.index_end + 1 < character_array_length) {
			// while possible, merge drawable with drawable at next index
			var can_merge = char_drawables_mergeable(index, character_array[index].drawable.index_end + 1);
			var drawable = character_array[index].drawable;
			var next_drawable = character_array[drawable.index_end + 1].drawable;
			if (can_merge) {
				drawable.text += next_drawable.text;
				drawable.index_end = next_drawable.index_end;
				for (var i = drawable.index_start; i <= drawable.index_end; i++) {
					character_array[i].drawable = drawable;
				}
			} else {
				index = next_drawable.index_start;
			}
		}
	};
	/// @ignore
	merge_all_drawables = function() {
		merge_drawables_at_index_range(0, character_array_length - 1);
	};
	
	/**
	 * @param {real} index_start first index to split at
	 * @param {real} index_end last index to split at, inclusive
	 * @ignore
	 */
	split_drawables_at_index_range = function(index_start, index_end) {
		if (index_start > index_end) return;
		var drawable_left = character_array[index_start].drawable;
		if (drawable_left.index_start != index_start) {
			var left_original_end = drawable_left.index_end;
			drawable_left.index_end = index_start - 1;
			drawable_left.text = "";
			for (var i = drawable_left.index_start; i <= drawable_left.index_end; i++) {
				drawable_left.text += character_array[i].char;
			}
			var new_drawable_left = {
				index_start: index_start,
				index_end: left_original_end,
				text: "",
				style: drawable_left.style.get_copy()
			};
			for (var i = index_start; i <= left_original_end; i++) {
				character_array[i].drawable = new_drawable_left;
				new_drawable_left.text += character_array[i].char;
			}
		}
		var drawable_right = character_array[index_end].drawable;
		if (drawable_right.index_end != index_end) {
			var right_original_end = drawable_right.index_end;
			drawable_right.index_end = index_end;
			drawable_right.text = "";
			for (var i = drawable_right.index_start; i <= drawable_right.index_end; i++) {
				drawable_right.text += character_array[i].char;
			}
			var new_drawable_right = {
				index_start: index_end + 1,
				index_end: right_original_end,
				text: "",
				style: drawable_right.style.get_copy()
			};
			for (var i = new_drawable_right.index_start; i <= new_drawable_right.index_end; i++) {
				character_array[i].drawable = new_drawable_right;
				new_drawable_right.text += character_array[i].char;
			}
		}
	};
	
	/// @ignore
	get_drawables = function() {
		var result = [];
		var index = 0;
		while (index < character_array_length) {
			var drawable = character_array[index].drawable;
			array_push(result, drawable);
			index = drawable.index_end + 1;
		}
		return result;
	};
	
	// character setters
	
	/// @ignore
	invoke_callback_on_character_range = function(index_start, index_end, callback) {
		var index_stop = min(array_length(character_array) - 1, index_end);
		for (var i = index_start; i <= index_stop; i++) {
			callback(character_array[i]);
		}
	};
	/// @ignore
	set_character_font = function(index_start, index_end, font) {
		invoke_callback_on_character_range(index_start, index_end, method({ font }, function(c) {
			if (is_string(font) && asset_get_type(font) != asset_font) show_error("name given for font command is not a font asset", true);
			c.style.font = asset_get_index(font);
		}));
	};
	/// @ignore
	set_character_color = function(index_start, index_end, color) {
		invoke_callback_on_character_range(index_start, index_end, method({ color }, function(c) {
			c.style.color = color;
		}));
	};
	/// @ignore
	set_character_alpha = function(index_start, index_end, alpha) {
		invoke_callback_on_character_range(index_start, index_end, method({ alpha }, function(c) {
			c.style.alpha = alpha;
		}));
	};
	/// @ignore
	set_character_scale_x = function(index_start, index_end, scale_x) {
		invoke_callback_on_character_range(index_start, index_end, method({ scale_x }, function(c) {
			c.style.scale_x = scale_x;
		}));
	};
	/// @ignore
	set_character_scale_y = function(index_start, index_end, scale_y) {
		invoke_callback_on_character_range(index_start, index_end, method({ scale_y }, function(c) {
			c.style.scale_y = scale_y;
		}));
	};
	/// @ignore
	set_character_offset_x = function(index_start, index_end, offset_x) {
		invoke_callback_on_character_range(index_start, index_end, method({ offset_x }, function(c) {
			c.style.offset_x = offset_x;
		}));
	};
	/// @ignore
	set_character_offset_y = function(index_start, index_end, offset_y) {
		invoke_callback_on_character_range(index_start, index_end, method({ offset_y }, function(c) {
			c.style.offset_y = offset_y;
		}));
	};
	/// @ignore
	set_character_new_line = function(index, new_line) {
		character_array[index].style.new_line = new_line;
	};
	/// @ignore
	set_character_sprite = function(index, sprite) {
		if (is_string(sprite) && asset_get_type(sprite) != asset_sprite) show_error("name given for sprite command is not a sprite asset", true);
		character_array[index].style.sprite = asset_get_index(sprite);
	};
	/// @ignore
	set_character_outline_distance = function(index_start, index_end, outline_distance) {
		invoke_callback_on_character_range(index_start, index_end, method({ outline_distance }, function(c) {
			c.style.outline_distance = outline_distance;
		}));
	};
	/// @ignore
	set_character_outline_color = function(index_start, index_end, outline_color) {
		invoke_callback_on_character_range(index_start, index_end, method({ outline_color }, function(c) {
			c.style.outline_color = outline_color;
		}));
	};
	/// @ignore
	set_character_outline_alpha = function(index_start, index_end, outline_alpha) {
		invoke_callback_on_character_range(index_start, index_end, method({ outline_alpha }, function(c) {
			c.style.outline_alpha = outline_alpha;
		}));
	};
	/// @ignore
	set_character_glow_start = function(index_start, index_end, glow_start) {
		invoke_callback_on_character_range(index_start, index_end, method({ glow_start }, function(c) {
			c.style.glow_start = glow_start;
		}));
	};
	/// @ignore
	set_character_glow_end = function(index_start, index_end, glow_end) {
		invoke_callback_on_character_range(index_start, index_end, method({ glow_end }, function(c) {
			c.style.glow_end = glow_end;
		}));
	};
	/// @ignore
	set_character_glow_color = function(index_start, index_end, glow_color) {
		invoke_callback_on_character_range(index_start, index_end, method({ glow_color }, function(c) {
			c.style.glow_color = glow_color;
		}));
	};
	/// @ignore
	set_character_glow_alpha = function(index_start, index_end, glow_alpha) {
		invoke_callback_on_character_range(index_start, index_end, method({ glow_alpha }, function(c) {
			c.style.glow_alpha = glow_alpha;
		}));
	};
	
	/// @ignore
	set_character_drop_shadow_softness = function(index_start, index_end, drop_shadow_softness) {
		invoke_callback_on_character_range(index_start, index_end, method({ drop_shadow_softness }, function(c) {
			c.style.drop_shadow_softness = drop_shadow_softness;
		}));
	};
	/// @ignore
	set_character_drop_shadow_offsetX = function(index_start, index_end, drop_shadow_offsetX) {
		invoke_callback_on_character_range(index_start, index_end, method({ drop_shadow_offsetX }, function(c) {
			c.style.drop_shadow_offsetX = drop_shadow_offsetX;
		}));
	};
	/// @ignore
	set_character_drop_shadow_offsetY = function(index_start, index_end, drop_shadow_offsetY) {
		invoke_callback_on_character_range(index_start, index_end, method({ drop_shadow_offsetY }, function(c) {
			c.style.drop_shadow_offsetY = drop_shadow_offsetY;
		}));
	};
	/// @ignore
	set_character_drop_shadow_color = function(index_start, index_end, drop_shadow_color) {
		invoke_callback_on_character_range(index_start, index_end, method({ drop_shadow_color }, function(c) {
			c.style.drop_shadow_color = drop_shadow_color;
		}));
	};	/// @ignore
	set_character_drop_shadow_alpha = function(index_start, index_end, drop_shadow_alpha) {
		invoke_callback_on_character_range(index_start, index_end, method({ drop_shadow_alpha }, function(c) {
			c.style.drop_shadow_alpha = drop_shadow_alpha;
		}));
	};
	
	// drawable setters
	
	/// @ignore
	drawable_set_color = function(index_start, index_end, color) {
		split_drawables_at_index_range(index_start, index_end);
		var index = index_start;
		while (index <= index_end) {
			character_array[index].drawable.style.color = color;
			index = character_array[index].drawable.index_end + 1;
		}
	};
	
	/// @ignore
	drawable_apply_alpha = function(index_start, index_end, alpha) {
		split_drawables_at_index_range(index_start, index_end);
		var index = index_start;
		while (index <= index_end) {
			character_array[index].drawable.style.alpha *= alpha;
			index = character_array[index].drawable.index_end + 1;
		}
	}
	
	/// @ignore
	drawable_add_offset_x = function(index_start, index_end, offset_x) {
		split_drawables_at_index_range(index_start, index_end);
		var index = index_start;
		while (index <= index_end) {
			character_array[index].drawable.style.offset_x += offset_x;
			index = character_array[index].drawable.index_end + 1;
		}
	}
	
	/// @ignore
	drawable_add_offset_y = function(index_start, index_end, offset_y) {
		split_drawables_at_index_range(index_start, index_end);
		var index = index_start;
		while (index <= index_end) {
			character_array[index].drawable.style.offset_y += offset_y;
			index = character_array[index].drawable.index_end + 1;
		}
	}
	
	/// @ignore
	build = function() {
		calculate_char_positions();
		merge_all_drawables();
	};
	
	/*
	Only drawables of current page are initialized after each draw. So
	on page switch the drawables must be initialized or there could be
	graphical errors.
	*/
	/// @ignore
	init_page_drawables = function() {
		var index = text_page_char_index_start[text_page_index];
		while (index <= text_page_char_index_end[text_page_index]) {
			character_array[index].drawable.style.set_to(character_array[index].style);
			index = character_array[index].drawable.index_end + 1;
		}
	};
	/// @ignore
	page_previous = function() {
		var prev = text_page_index;
		text_page_index = max(text_page_index - 1, 0);
		if (text_page_index != prev) init_page_drawables();
	};
	/// @ignore
	page_next = function() {
		var prev = text_page_index;
		text_page_index = min(text_page_index + 1, text_page_index_max);
		if (text_page_index != prev) init_page_drawables();
	};
	/// @ignore
	draw = function(x, y) {
		x = floor(x);
		y = floor(y);
		var original_halign = draw_get_halign();
		var original_valign = draw_get_valign();
		var original_font = draw_get_font();
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		
		if (array_length(text_page_widths) <= 0) {
			draw_set_alpha(1);
			draw_set_color(c_white);
			draw_set_font(fnt_styleable_text_font_default);
			draw_text(x, y, "Text must be made drawable.");
			return;
		}
		
		var page_width = text_page_widths[text_page_index];
		var page_height = text_page_heights[text_page_index];
		
		var text_box_x = x;
		var text_box_y = y;
		
		var box_x = x;
		var box_y = y;
		if (original_halign == fa_center) {
			box_x -= floor(page_width / 2);
			text_box_x -= floor(get_width() / 2);
		}
		if (original_halign == fa_right) {
			box_x -= page_width;
			text_box_x -= get_width();
		}
		if (original_valign == fa_middle) {
			box_y -= floor(page_height / 2);
			text_box_y -= floor(get_height() / 2);
		}
		if (original_valign == fa_bottom) {
			box_y -= page_height;
			text_box_y -= get_height();
		}
		
		if (debug) {
			var before_debug_box_alpha = draw_get_alpha();
			draw_set_alpha(1);
			draw_set_font(fnt_styleable_text_font_default);
			draw_set_color(c_lime);
			var drawables = get_drawables();
			draw_text(box_x, box_y - 30, $"drawables: {array_length(drawables)}");
			// debug border overlaps text area on all sides
			// page
			draw_rectangle(box_x, box_y, box_x + 1, box_y + page_height, false);
			draw_rectangle(box_x + page_width - 1, box_y, box_x + page_width, box_y + page_height, false);
			draw_rectangle(box_x, box_y, box_x + page_width, box_y + 1, false);
			draw_rectangle(box_x, box_y + page_height - 1, box_x + page_width, box_y + page_height, false);
		
			// text
			draw_set_color(c_aqua);
			draw_rectangle(text_box_x, text_box_y, text_box_x + 1, text_box_y + get_height(), false);
			draw_rectangle(text_box_x + get_width() - 1, text_box_y, text_box_x + get_width(), text_box_y + get_height(), false);
			draw_rectangle(text_box_x, text_box_y, text_box_x + get_width(), text_box_y + 1, false);
			draw_rectangle(text_box_x, text_box_y + get_height() - 1, text_box_x + get_width(), text_box_y + get_height(), false);
		
			draw_set_color(c_fuchsia);
			draw_rectangle(x, y, x + 1, y + 1, false);
			draw_set_alpha(before_debug_box_alpha);
		}
		
		var index = text_page_char_index_start[text_page_index]; // starting character of current page
		while (index <= text_page_char_index_end[text_page_index]) {
			var c = character_array[index];
			var drawable = c.drawable;
			if (c.page_index == text_page_index && drawable.style.alpha > 0) {
				draw_set_font(drawable.style.font);
				
				var sdf_effects_enabled = drawable.style.outline_alpha > 0 || drawable.style.glow_alpha > 0 || drawable.style.drop_shadow_alpha > 0;
				font_enable_effects(drawable.style.font, sdf_effects_enabled, {
					outlineEnable: drawable.style.outline_alpha > 0,
					outlineDistance: drawable.style.outline_distance,
					outlineColour: drawable.style.outline_color,
					outlineAlpha: drawable.style.outline_alpha,
					glowEnable: drawable.style.glow_alpha > 0, 
					glowStart: drawable.style.glow_start,
					glowEnd: drawable.style.glow_end,
					glowColour: drawable.style.glow_color,
					glowAlpha: drawable.style.glow_alpha,
					dropShadowEnable: drawable.style.drop_shadow_alpha > 0,
					dropShadowSoftness: drawable.style.drop_shadow_softness,
					dropShadowOffsetX: drawable.style.drop_shadow_offsetX,
					dropShadowOffsetY: drawable.style.drop_shadow_offsetY,
					dropShadowColour: drawable.style.drop_shadow_color,
					dropShadowAlpha: drawable.style.drop_shadow_alpha,
				});
				
				var width_diff = page_width - text_line_widths[c.line_index];
				var halign_offset = 0;
				
				var drawable_height = drawable.style.scale_y * (drawable.style.sprite == spr_styleable_text_sprite_default ? string_height(drawable.text) : sprite_get_height(drawable.style.sprite));
				var line_height = text_line_heights[c.line_index];
				var vcentering = floor((line_height - drawable_height) / 2);
				
				if (original_halign == fa_right) halign_offset = width_diff;
				if (original_halign == fa_center) halign_offset = floor(width_diff / 2);
				var draw_x = box_x + c.x + halign_offset + drawable.style.offset_x;
				var draw_y = box_y + c.y + drawable.style.offset_y + vcentering;
				
				if (drawable.style.sprite == spr_styleable_text_sprite_default) {
					draw_text_transformed_color(
						draw_x,
						draw_y,
						drawable.text,
						drawable.style.scale_x,
						drawable.style.scale_y,
						0,
						drawable.style.color,
						drawable.style.color,
						drawable.style.color,
						drawable.style.color,
						drawable.style.alpha * draw_get_alpha()
					);
				} else {
					draw_sprite_ext(
						drawable.style.sprite,
						0,
						draw_x,
						draw_y,
						drawable.style.scale_x,
						drawable.style.scale_y,
						0,
						drawable.style.color,
						drawable.style.alpha * draw_get_alpha()
					);
				}
			}
			index = drawable.index_end + 1;
			drawable.style.set_to(c.style);
		}
		draw_set_halign(original_halign);
		draw_set_valign(original_valign);
		draw_set_font(original_font);
	};
}
