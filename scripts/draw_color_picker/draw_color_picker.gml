function draw_color_picker() {
	
	var diam = 150;
	var winw = 520;
	var winh = diam+10;
	
	var off = winh;
	
	var py = display_get_gui_height() - _color_wheel.wy * off - 20;
	var px = 30;
	
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	
	if !_mouse_started_on_paper
	and (point_in_rectangle(mx, my, px, py-30, px+winw, py+winh+200)
	or point_in_rectangle(mx, my, -200, display_get_gui_height() - 20 - 64, px+64, display_get_gui_height()+200)
	or string_pos("cp_", _selected_slider + _selected_input) != 0 or _color_wheel.msi) {
		_mouse_over_gui = true;
		_color_wheel.wy = lerp(_color_wheel.wy, 1, 0.1);
	}
	else _color_wheel.wy = lerp(_color_wheel.wy, -0.5, 0.1);
	
	var yyy = display_get_gui_height() - 120 - _color_wheel.wy * off * 0.5  - _bottom_bar.h;
	
	draw_sprite_ext(spr_rgb_wheel_64, 0, px-10, yyy, 1, 1, 0, c_white, 1 - clamp(_color_wheel.wy, 0, 1));
	draw_sprite_ext(spr_checkers2, 0, px + 64, yyy+32, 1, 1, 0, c_white, 1 - clamp(_color_wheel.wy, 0, 1));
	draw_sprite_ext(spr_1px, 0, px + 64, yyy+32, 30, 30, 0, rgba2c(_brush.col, 255, false), (1 - clamp(_color_wheel.wy, 0, 1)) * _brush.col[3]);
	draw_set_color(c_black);
	draw_set_alpha(1 - clamp(_color_wheel.wy, 0, 1));
	draw_rectangle(px + 64, yyy+32, px + 64 + 29, yyy+32 + 29, true);
	draw_set_alpha(1);
	
	draw_set_color(c_dkgray);
	draw_rectangle(px-10, py-10, px+winw, py+winh, false);
	
	_color_wheel.surf = check_surf(_color_wheel.surf, diam, diam);
	_color_wheel.size_surf = check_surf(_color_wheel.size_surf, diam, diam);
	
	shader_set(shd_color_wheel);
	shader_set_uniform_f(shader_get_uniform(shd_color_wheel, "v"), _color_wheel.v);
	surface_set_target(_color_wheel.surf);
	draw_surface(_color_wheel.size_surf, 0, 0);
	surface_reset_target();
	shader_reset();
	
	if _color_wheel.pos[0] == -1 {
		set_text_from_sliders();
		_color_wheel.pos = [diam/2, diam/2];
	}
	
	draw_surface(_color_wheel.surf, px, py);
	
	draw_set_color(c_black);
	draw_set_alpha(0.35);
	draw_circle_ext(px+diam/2, py+diam/2, diam/2, 2, 50);
	draw_set_alpha(1);
	
	if mouse_check_button_released(mb_left) _color_wheel.msi = false;
	if mouse_check_button_pressed(mb_left) and point_distance(px+diam/2, py+diam/2, mx, my) < diam/2 _color_wheel.msi = true;
	
	if mouse_check_button_pressed(mb_left) 
	or mouse_check_button_released(mb_left) _color_wheel.prev_rgba = [_color_wheel.r, _color_wheel.g, _color_wheel.b, _color_wheel.a];
	
	if mouse_check_button(mb_left) and _color_wheel.msi {
		if point_distance(px+diam/2, py+diam/2, mx, my) <= diam/2 {
			_color_wheel.pos = [mx - px, my - py];
		}
		else {
			var pdr = point_direction(px+diam/2, py+diam/2, mx, my);
			var xx = px+diam/2+lengthdir_x(diam/2, pdr);
			var yy = py+diam/2+lengthdir_y(diam/2, pdr);
			_color_wheel.pos = [xx - px, yy - py];
		}
		
		var r = diam * 0.5;
		_color_wheel.h = 1 - point_direction(r, r, _color_wheel.pos[0], _color_wheel.pos[1]) / 360;
		_color_wheel.s = point_distance(r, r, _color_wheel.pos[0], _color_wheel.pos[1]) / r;
	
		_selected_slider = "cp_W";
	}
	
	draw_set_color(c_white);
	draw_circle(px + _color_wheel.pos[0], py + _color_wheel.pos[1], 5, true);
	draw_set_color(c_black);
	draw_circle(px + _color_wheel.pos[0], py + _color_wheel.pos[1], 6, true);
	
	draw_set_color(rgba2c(_color_wheel.prev_rgba));
	draw_triangle(px-5, py-5, px+35, py-5, px+14, py+15, false);
	draw_set_color(rgba2c(_brush.col));
	draw_triangle(px-5, py-5, px+14, py+15, px-5, py+35, false);
	draw_set_color(c_black);
	draw_triangle(px-5, py-5, px+35, py-5, px-5, py+35, true);
	
	var rgb255 = [_color_wheel.r * 255, _color_wheel.g * 255, _color_wheel.b * 255];
	
	var bottom_red = make_color_rgb(0, rgb255[1], rgb255[2]);
	var bottom_green = make_color_rgb(rgb255[0], 0, rgb255[2]);
	var bottom_blue = make_color_rgb(rgb255[0], rgb255[1], 0);
	var upper_red = make_color_rgb(255, rgb255[1], rgb255[2]);
	var upper_green = make_color_rgb(rgb255[0], 255, rgb255[2]);
	var upper_blue = make_color_rgb(rgb255[0], rgb255[1], 255);
	
	var curr_col = make_color_rgb(rgb255[0], rgb255[1], rgb255[2]);
	var curr_col_full_s = make_color_hsv(_color_wheel.h * 255, 255, _color_wheel.v * 255);
	
	draw_set_color(make_color_rgb(255, 100, 100));
	draw_text(px+diam+13, py+15, "R");
	draw_set_color(c_lime);
	draw_text(px+diam+13, py+15+16+10, "G");
	draw_set_color(c_aqua);
	draw_text(px+diam+13, py+15+16*2+20, "B");
	draw_set_color(c_white);
	draw_text(px+diam+13, py+15+16*4+33, "A");
	
	draw_text(px+diam+13+175, py+15, "H");
	draw_text(px+diam+13+175, py+15+16+10, "S");
	draw_text(px+diam+13+175, py+15+16*2+20, "V");
	draw_text(px+diam+13+175, py+15+16*4+33, chr(35));
	
	draw_rectangle_color(px+diam+32, py+16, px+diam+32+100, py+16+16, bottom_red, upper_red, upper_red, bottom_red, false);
	_color_wheel.r = h_slider(px+diam+32, py+16, 100, 16, _color_wheel.r, "cp_R");
	input_draw("cp_R", px+diam+32+106, py+16-4, mx, my);
	
	draw_rectangle_color(px+diam+32, py+16*2+10, px+diam+32+100, py+16*2+10+16, bottom_green, upper_green, upper_green, bottom_green, false);
	_color_wheel.g = h_slider(px+diam+32, py+16*2+10, 100, 16, _color_wheel.g, "cp_G");
	input_draw("cp_G", px+diam+32+106, py+16*2+10-4, mx, my);
	
	draw_rectangle_color(px+diam+32, py+16*3+20, px+diam+32+100, py+16*3+20+16, bottom_blue, upper_blue, upper_blue, bottom_blue, false);
	_color_wheel.b = h_slider(px+diam+32, py+16*3+20, 100, 16, _color_wheel.b, "cp_B");
	input_draw("cp_B", px+diam+32+106, py+16*3+20-4, mx, my);
	
	draw_sprite_ext(spr_alpha, 1, px+diam+32+100, py+16*4+50, 1, 1, -90, c_white, 1);
	draw_sprite_ext(spr_alpha, 0, px+diam+32+100, py+16*4+50, 1, 1, -90, curr_col, 1);
	_color_wheel.a = h_slider(px+diam+32, py+16*4+50, 100, 16, _color_wheel.a, "cp_A");
	input_draw("cp_A", px+diam+32+106, py+16*4+50-4, mx, my);
	
	draw_sprite_ext(spr_hue, 0, px+diam+32+175+100, py+16, 1, 1, -90, c_white, 1);
	_color_wheel.h = h_slider(px+diam+32+175, py+16, 100, 16, _color_wheel.h, "cp_H");
	input_draw("cp_H", px+diam+32+175+106, py+16-4, mx, my);
	
	draw_rectangle_color(px+diam+32+175, py+16*2+10, px+diam+32+175+100, py+16*2+10+16, c_white, curr_col_full_s, curr_col_full_s, c_white, false);
	_color_wheel.s = h_slider(px+diam+32+175, py+16*2+10, 100, 16, _color_wheel.s, "cp_S");
	input_draw("cp_S", px+diam+32+175+106, py+16*2+10-4, mx, my);
	
	draw_rectangle_color(px+diam+32+175, py+16*3+20, px+diam+32+175+100, py+16*3+20+16, c_black, c_white, c_white, c_black, false);
	_color_wheel.v = h_slider(px+diam+32+175, py+16*3+20, 100, 16, _color_wheel.v, "cp_V");
	input_draw("cp_V", px+diam+32+175+106, py+16*3+20-4, mx, my);
	
	input_draw("cp_HEX", px+diam+32+175, py+16*4+50-4, mx, my);
	
	if _selected_slider != "" {
		set_text_from_sliders();
	}
	else if _selected_input != "" {
		var t = input_get_text(_selected_input);
		
		if _selected_input == "cp_HEX" {
				input_set_text("cp_HEX", string_upper(t));
				if string_length(t) == 6 {
			
				var bgr_c = hex2dec(t);
				var rgb_c = make_color_rgb(color_get_blue(bgr_c), color_get_green(bgr_c), color_get_red(bgr_c));
			
				_color_wheel.h = color_get_hue(rgb_c)/255;
				_color_wheel.s = color_get_saturation(rgb_c)/255;
				_color_wheel.v = color_get_value(rgb_c)/255;
				_color_wheel.r = color_get_red(rgb_c)/255;
				_color_wheel.g = color_get_green(rgb_c)/255;
				_color_wheel.b = color_get_blue(rgb_c)/255;
			
				_color_wheel.pos = [
					diam/2 + lengthdir_x(_color_wheel.s * diam/2, _color_wheel.h * -360),
					diam/2 + lengthdir_y(_color_wheel.s * diam/2, _color_wheel.h * -360)
				];
			
				set_text_from_sliders(false);
			}
		}
		else {
			if t != "" and t == string_digits(t) {
				switch(_selected_input) {
					case "cp_R": _color_wheel.r = round(clamp(real(t), 0, 255)) / 255; input_set_text(_selected_input, _color_wheel.r * 255); break;
					case "cp_G": _color_wheel.g = round(clamp(real(t), 0, 255)) / 255; input_set_text(_selected_input, _color_wheel.g * 255); break;
					case "cp_B": _color_wheel.b = round(clamp(real(t), 0, 255)) / 255; input_set_text(_selected_input, _color_wheel.b * 255); break;
					case "cp_A": _color_wheel.a = round(clamp(real(t), 0, 255)) / 255; input_set_text(_selected_input, _color_wheel.a * 255); break;
					case "cp_H": _color_wheel.h = round(clamp(real(t), 0, 255)) / 255; input_set_text(_selected_input, _color_wheel.h * 255); break;
					case "cp_S": _color_wheel.s = round(clamp(real(t), 0, 255)) / 255; input_set_text(_selected_input, _color_wheel.s * 255); break;
					case "cp_V": _color_wheel.v = round(clamp(real(t), 0, 255)) / 255; input_set_text(_selected_input, _color_wheel.v * 255); break;
				}
			}
		}
	}
	
	if _selected_slider == "cp_R" 
	or _selected_slider == "cp_G" 
	or _selected_slider == "cp_B" {
	
		var new_c = make_color_rgb(_color_wheel.r * 255, _color_wheel.g * 255, _color_wheel.b * 255);
		
		_color_wheel.h = color_get_hue(new_c)/255;
		_color_wheel.s = color_get_saturation(new_c)/255;
		_color_wheel.v = color_get_value(new_c)/255;
			
		_color_wheel.pos = [
			diam/2 + lengthdir_x(_color_wheel.s * diam/2, _color_wheel.h * -360),
			diam/2 + lengthdir_y(_color_wheel.s * diam/2, _color_wheel.h * -360)
		];
	}
	else if _selected_slider == "cp_H"
	or _selected_slider == "cp_S" 
	or _selected_slider == "cp_V" 
	or _selected_slider == "cp_W" {
	
		var new_c = make_color_hsv(_color_wheel.h * 255, _color_wheel.s * 255, _color_wheel.v * 255);
		
		_color_wheel.r = color_get_red(new_c)/255;
		_color_wheel.g = color_get_green(new_c)/255;
		_color_wheel.b = color_get_blue(new_c)/255;
			
		_color_wheel.pos = [
			diam/2 + lengthdir_x(_color_wheel.s * diam/2, _color_wheel.h * -360),
			diam/2 + lengthdir_y(_color_wheel.s * diam/2, _color_wheel.h * -360)
		];
	}
	
	_brush.col = [_color_wheel.r, _color_wheel.g, _color_wheel.b, _color_wheel.a];
}

function set_text_from_sliders(also_hex = true) {
	input_set_text("cp_R", round(_color_wheel.r * 255));
	input_set_text("cp_G", round(_color_wheel.g * 255));
	input_set_text("cp_B", round(_color_wheel.b * 255));
	input_set_text("cp_A", round(_color_wheel.a * 255));
	input_set_text("cp_H", round(_color_wheel.h * 255));
	input_set_text("cp_S", round(_color_wheel.s * 255));
	input_set_text("cp_V", round(_color_wheel.v * 255));
	if also_hex input_set_text("cp_HEX", dec2hex(_color_wheel.r * 255) + dec2hex(_color_wheel.g * 255) + dec2hex(_color_wheel.b * 255));
}

function hex2dec(hex) {
	
	hex = string_upper(hex);
	
	var dec = 0;
	var chars = "0123456789ABCDEF";
	var len = string_length(hex);
	
	for(var pos = 1; pos < len+1; pos++) {
		dec = dec << 4 | (string_pos(string_char_at(hex, pos), chars) - 1);
	}
	
	return real(dec);
}

function dec2hex(dec) {
	
	var chars = "0123456789ABCDEF";
	var hex = "";
	
	while(true) {
        hex = string_char_at(chars, (dec % 16) + 1) + hex;
        dec = dec / 16;
		if dec < 1 break;
	}
	
	while(string_length(hex) < 2) hex = "0" + hex;
	return hex;
}
