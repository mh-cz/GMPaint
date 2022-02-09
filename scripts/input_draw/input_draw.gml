/// input_init()
//
// call this once when the game starts
//
/// GMLscripts.com/license

function input_init() {
	
	global.input_map = ds_map_create();
}

/// input_create(input_id)
// 
// 	input_id	string
// 
// create a new inputbox under this input_id
//
/// GMLscripts.com/license

function input_create(input_id) {
	
	global.input_map[? input_id] = {
		
		str : "",
		placeholder_text : "",
		prev_str : "",
		input_w : 300,
		input_h : 32,
		hold_delay : 0.25,
		spam_delay : 0.02,
		hold_timer : 0,
		spam_timer : 0,
		cursor_flick_speed : 0.4,
		cursor_flick_timer : 0,
		char_spacing : 1,
		cursor_pos : 0,
		cursor_vis : true,
		has_focus : false,
		max_chars : 29,
		clamp_width : true,
		font : -1,
		padding : 4,
		text_color : c_white,
		placeholder_text_color : c_black,
		cursor_color : c_white,
		bkg_color : c_dkgray,
		focused_bkg_color : merge_color(c_dkgray, c_white, 0.15),
		bkg_alpha : 1,
		focused_bkg_alpha : 1,
		focused_text_color : c_white
	};
}

/// input_delete(input_id)
// 
// 	input_id	string
// 
// delete an inputbox under this input_id
//
/// GMLscripts.com/license

function input_delete(input_id) {
	
	global.input_map[? input_id] = 0;
}

/// input_draw(input_id, x, y)
// 
// 	input_id	string
// 	x	inputbox x position, real
// 	y	inputbox y position, real
// 
// call in any draw or draw GUI event
//
/// GMLscripts.com/license

function input_draw(input_id, x, y, mx, my) {
	
	var s = global.input_map[? input_id];
	
	if is_struct(s) {
	
		if device_mouse_check_button_pressed(0, mb_left) {
			_selected_input = "";
			s.has_focus = point_in_rectangle(mx, my, x, y, x + s.input_w, y + s.input_h) and _mouse_over_gui;
		}
		
		var slen = string_length(s.str);
		
		if s.has_focus {
			
			_selected_input = input_id;
			
			// TYPING
			if keyboard_check(vk_anykey) {
	
				s.str = string_insert(keyboard_string, s.str, s.cursor_pos+1);
			
				if s.prev_str != s.str {
					s.cursor_pos += string_length(keyboard_string);
					s.cursor_flick_timer = 0;
					s.cursor_vis = true;
				}
				s.prev_str = s.str;
		
				slen = string_length(s.str);
			}
	
			keyboard_string = "";
	
			// KEYS

			if keyboard_check_pressed(vk_right)
			or keyboard_check_pressed(vk_left)
			or keyboard_check_pressed(vk_backspace)
			or keyboard_check_pressed(vk_delete)
			or device_mouse_check_button_pressed(0, mb_left) {
	
				s.hold_timer = 0;
				s.spam_timer = s.spam_delay * room_speed + 1;
				s.cursor_flick_timer = 0;
				s.cursor_vis = true;
			}

			// ctrl+v
			if keyboard_check_pressed(ord("V")) and keyboard_check(vk_control) {

				if clipboard_has_text() {
		
					var cb = clipboard_get_text();
					s.str += cb;
					s.cursor_pos += string_length(cb);
					slen = string_length(s.str);
				}
			}
			// backspace key
			if keyboard_check_pressed(vk_backspace) or (keyboard_check(vk_backspace) and s.hold_timer++ > s.hold_delay * room_speed) {
	
				s.cursor_flick_timer = 0;
				s.cursor_vis = true;
	
				if s.spam_timer++ > s.spam_delay * room_speed {
		
					s.spam_timer = 0;
		
					if s.cursor_pos > 0 {
			
						s.str = string_delete(s.str, s.cursor_pos--, 1);
						slen = string_length(s.str);
					}
				}
			}
			// delete key
			if keyboard_check_pressed(vk_delete) or (keyboard_check(vk_delete) and s.hold_timer++ > s.hold_delay * room_speed) {
	
				s.cursor_flick_timer = 0;
				s.cursor_vis = true;
	
				if s.spam_timer++ > s.spam_delay * room_speed {
		
					s.spam_timer = 0;
		
					if s.cursor_pos < slen {
			
						s.str = string_delete(s.str, s.cursor_pos+1, 1);
						slen = string_length(s.str);
					}
				}
			}
			// move cursor right
			if keyboard_check_pressed(vk_right) or (keyboard_check(vk_right) and s.hold_timer++ > s.hold_delay * room_speed) {
	
				s.cursor_flick_timer = 0;
				s.cursor_vis = true;
	
				if s.spam_timer++ > s.spam_delay * room_speed {
		
					s.spam_timer = 0;
					s.cursor_pos++;
				}
			}
			// move cursor left
			if keyboard_check_pressed(vk_left) or (keyboard_check(vk_left) and s.hold_timer++ > s.hold_delay * room_speed) {
	
				s.cursor_flick_timer = 0;
				s.cursor_vis = true;
	
				if s.spam_timer++ > s.spam_delay * room_speed {
		
					s.spam_timer = 0;
					s.cursor_pos--;
				}
			}
		}
		else {
			s.cursor_flick_timer = 0;
			s.cursor_vis = false;
		}
		// text max length clamp
		if string_length(s.str) > s.max_chars s.str = string_copy(s.str, 1, s.max_chars);

		// MOUSE + DRAW

		if s.has_focus {
			draw_set_color(s.focused_bkg_color);
			draw_set_alpha(s.focused_bkg_alpha);
		}
		else {
			draw_set_color(s.bkg_color);
			draw_set_alpha(s.bkg_alpha);
		}

		draw_rectangle(x, y, x + s.input_w, y + s.input_h, false);

		draw_set_alpha(1);
		draw_set_font(s.font);
		draw_set_color(s.placeholder_text_color);

		// placeholder text
		if slen == 0 draw_text(x + s.padding, y + s.padding, s.placeholder_text);

		if s.has_focus {
			draw_set_color(s.focused_text_color);
		}
		else {
			draw_set_color(s.text_color);
		}

		var chrx = s.padding;
		var nearest_dist = 9999999;

		for(var i = 0; i < slen+2; i++) {
			// move cursor to mouse position
			if s.has_focus and device_mouse_check_button_pressed(0, mb_left) {
		
				var check_curs_pos = x + chrx;
				var dist = abs(mx - check_curs_pos);
		
				if dist < nearest_dist {
			
					nearest_dist = dist;
					s.cursor_pos = i-1;
				}
			}
			// draw each character of the text
			if i == clamp(i, 1, slen+1) {
		
				var ch = string_char_at(s.str, i);
				var chw = string_width(ch);
		
				draw_text(x + chrx, y + s.padding, ch)
		
				chrx += chw + s.char_spacing;
		
				if s.clamp_width and i < slen {
			
					if chrx + string_width(string_char_at(s.str, i+1)) + s.padding > s.input_w {
			
						s.str = string_copy(s.str, 1, i);
						s.cursor_pos = i;
						slen = string_length(s.str);
						break;
					}
				}
			}
		}

		// CURSOR STUFF

		s.cursor_pos = clamp(s.cursor_pos, 0, slen);

		if s.cursor_flick_timer++ > s.cursor_flick_speed * room_speed {
	
			s.cursor_flick_timer = 0;
			s.cursor_vis = !s.cursor_vis;
		}

		draw_set_color(s.cursor_color);

		if s.cursor_vis {
	
			var cx = s.padding + string_width(string_copy(s.str, 1, s.cursor_pos)) + s.cursor_pos * s.char_spacing;
			draw_line(
				x + cx,
				y + s.padding - 2,
				x + cx,
				y + s.padding + 2 + string_height("I")
				);
		}
	}
	else show_debug_message("Unknown input ID: " + input_id);
}

/// input_copy(input_id, new_input_id)
// 
// 	input_id	string
// 	new_input_id	string
//
/// GMLscripts.com/license

function input_copy(input_id, new_input_id) {
	
	input_create(new_input_id);
	
	var s1 = global.input_map[? input_id];
	var s2 = global.input_map[? new_input_id];
	
	if is_struct(s1) and is_struct(s2) {
		
		s2.str = s1.str;
		s2.placeholder_text = s1.placeholder_text;
		s2.input_w = s1.input_w;
		s2.input_h = s1.input_h;
		s2.hold_delay = s1.hold_delay;
		s2.spam_delay = s1.spam_delay;
		s2.cursor_flick_speed = s1.cursor_flick_speed;
		s2.char_spacing = s1.char_spacing;
		s2.max_chars = s1.max_chars;
		s2.clamp_width = s1.clamp_width;
		s2.font = s1.font;
		s2.padding = s1.padding;
		s2.text_color = s1.text_color;
		s2.focused_text_color = s1.focused_text_color;
		s2.placeholder_text_color = s1.placeholder_text_color;
		s2.cursor_color = s1.cursor_color;
		s2.bkg_color = s1.bkg_color;
		s2.focused_bkg_color = s1.focused_bkg_color;
		s2.bkg_alpha = s1.bkg_alpha;
		s2.focused_bkg_alpha = s1.focused_bkg_alpha;
	}
}

/// Functions to control the inputbox properties and look

// return what's inside the inputbox
//	input_id	string
function input_get_text(input_id) {
	var s = global.input_map[? input_id];
	return is_struct(s) ? s.str : "";
}

// set the text inside of the inputbox
//	input_id	string
//	text	string
function input_set_text(input_id, text) {
	var s = global.input_map[? input_id];
	if is_struct(s) s.str = text;
}

// only when the inputbox is focused you can type in
// you can focus it using mouse or using this script
// just make sure to focus only one inputbox
//	input_id	string
//	focus	bool
function input_set_focus(input_id, focus) {
	var s = global.input_map[? input_id];
	if is_struct(s) s.has_focus = focus;
}

// resize the inputbox (this doesn't shrink the text)
//	input_id	string
//	w	real
//	h	real
function input_set_dimensions(input_id, w, h) {
	var s = global.input_map[? input_id];
	if is_struct(s) {
		s.input_w = w;
		s.input_h = h;
	}
}

// max characters limit
// set it to something high like 99999 if you don't want to use it
//	input_id	string
//	max_chars	real
function input_set_max_chars(input_id, max_chars) {
	var s = global.input_map[? input_id];
	if is_struct(s) s.max_chars = max_chars;
}

// if clamp is true you will not be able to write more text if you reach the end of the inputbox
//	input_id	string
//	clamp	bool
function input_set_clamp_text_width(input_id, clamp) {
	var s = global.input_map[? input_id];
	if is_struct(s) s.clamp_width = clamp;
}

// set the placeholder text
// this text will only show up when the inputbox is empty
//	input_id	string
//	text	string
function input_set_placeholder_text(input_id, text) {
	var s = global.input_map[? input_id];
	if is_struct(s) s.placeholder_text = string(text);
}

// font
// -1 is default
//	input_id	string
//	font	font
function input_set_font(input_id, font) {
	var s = global.input_map[? input_id];
	if is_struct(s) s.font = font;
}

// move the text further away from borders
//	input_id	string
//	padding	real
function input_set_text_padding(input_id, padding) {
	var s = global.input_map[? input_id];
	if is_struct(s) s.padding = padding;
}

// text color
//	input_id	string
//	col	colour
function input_set_text_color(input_id, col) {
	var s = global.input_map[? input_id];
	if is_struct(s) s.text_color = col;
}

// focused text color
//	input_id	string
//	col	colour
function input_set_focused_text_color(input_id, col) {
	var s = global.input_map[? input_id];
	if is_struct(s) s.focused_text_color = col;
}

// placeholder text color
//	input_id	string
//	col	colour
function input_set_placeholder_text_color(input_id, col) {
	var s = global.input_map[? input_id];
	if is_struct(s) s.placeholder_text_color = col;
}

// background color
//	input_id	string
//	col	colour
function input_set_bkg_color(input_id, col) {
	var s = global.input_map[? input_id];
	if is_struct(s) s.bkg_color = col;
}

// focused background color
//	input_id	string
//	col	colour
function input_set_focused_bkg_color(input_id, col) {
	var s = global.input_map[? input_id];
	if is_struct(s) s.focused_bkg_color = col;
}

// background alpha
//	input_id	string
//	alpha	real
function input_set_bkg_alpha(input_id, alpha) {
	var s = global.input_map[? input_id];
	if is_struct(s) s.bkg_alpha = alpha;
}

// focused background alpha
//	input_id	string
//	alpha	real
function input_set_focused_bkg_alpha(input_id, alpha) {
	var s = global.input_map[? input_id];
	if is_struct(s) s.focused_bkg_alpha = alpha;
}

// cursor color
//	input_id	string
//	col	colour
function input_set_cursor_color(input_id, col) {
	var s = global.input_map[? input_id];
	if is_struct(s) s.cursor_color = col;
}

// how long you need to hold a key before the cursor starts going on its own (in seconds)
//	input_id	string
//	delay	real
function input_set_cursor_hold_delay(input_id, delay) {
	var s = global.input_map[? input_id];
	if is_struct(s) s.hold_delay = delay;
}

// delay when the cursor is going on its own  (in seconds)
//	input_id	string
//	delay	real
function input_set_cursor_spam_delay(input_id, delay) {
	var s = global.input_map[? input_id];
	if is_struct(s) s.spam_delay = delay;
}

// cursor flickering speed (in seconds)
//	input_id	string
//	spd	real
function input_set_cursor_flick_speed(input_id, spd) {
	var s = global.input_map[? input_id];
	if is_struct(s) s.cursor_flick_speed = spd;
}

// spacing between characters
//	input_id	string
//	space	real
function input_set_char_spacing(input_id, space) {
	var s = global.input_map[? input_id];
	if is_struct(s) s.char_spacing = space;
}