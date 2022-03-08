function options_brush() {
	
	var xx = 120;
	var yy = 40;
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	
	draw_set_alpha(0.5);
	draw_set_color(c_dkgray);
	draw_rectangle(xx-8, yy, xx+320, yy+80+32, false);
	draw_set_color(c_black);
	draw_rectangle(xx-8, yy, xx+320, yy+80+32, true);
	draw_set_alpha(1);
	
	draw_set_color(c_dkgray);
	draw_rectangle(xx, yy+16, xx+100, yy+32, false);
	draw_rectangle(xx, yy+16+32, xx+100, yy+32+32, false);
	draw_rectangle(xx, yy+16+64, xx+100, yy+32+64, false);
	draw_rectangle(xx+160, yy+16, xx+100+160, yy+32, false);
	draw_set_color(c_black);
	draw_rectangle(xx, yy+16, xx+100, yy+32, true);
	draw_rectangle(xx, yy+16+32, xx+100, yy+32+32, true);
	draw_rectangle(xx, yy+16+64, xx+100, yy+32+64, true);
	draw_rectangle(xx+160, yy+16, xx+100+160, yy+32, true);
	
	if point_in_rectangle(mx, my, xx-32, yy-32, xx+320, yy+80+32) _mouse_over_gui = true;
	
	_brush.size = round(min(sqr(h_slider(xx, yy+16, 100, 16, sqrt((_brush.size - 1) / 200), "s brush size", mx, my)) * 200 + 1, 200));
	_brush.falloff = sqr(sqr(h_slider(xx, yy+16+32, 100, 16, sqrt(sqrt((_brush.falloff - 1)/9)), "s brush falloff", mx, my))) * 9 + 1;
	_brush.step_scale = min(h_slider(xx, yy+16+64, 100, 16, _brush.step_scale - 0.01, "s brush spacing", mx, my) + 0.01, 1);
	_brush.weight = min(h_slider(xx+160, yy+16, 100, 16, _brush.weight - 0.01, "s brush weight", mx, my) + 0.01, 1);
	
	draw_set_colour(c_white);
	draw_set_alpha(0.65);
	draw_set_font(font_open_sans_9);
	draw_text(xx+4, yy+17, _langstr[$ _language].brush_option_size);
	draw_text(xx+4, yy+17+32, _langstr[$ _language].brush_option_falloff);
	draw_text(xx+4, yy+17+64, _langstr[$ _language].brush_option_spacing);
	draw_text(xx+4+160, yy+17, _langstr[$ _language].brush_option_weight);
	draw_set_alpha(1);
	
	input_draw("brush size", xx+106, yy+12, mx, my);
	input_draw("brush falloff", xx+106, yy+12+32, mx, my);
	input_draw("brush spacing", xx+106, yy+12+64, mx, my);
	input_draw("brush weight", xx+106+160, yy+12, mx, my);
	
	if !_brush.options_init {
		_brush.options_init = true;
		surface_resize(_brush.size_surf, _brush.size, _brush.size);
		surface_resize(_brush.brush_surf, _brush.size, _brush.size);
		input_set_text("brush size", _brush.size);
		input_set_text("brush falloff", _brush.falloff);
		input_set_text("brush spacing", _brush.step_scale);
		input_set_text("brush weight", _brush.weight);
	}
	
	switch(_selected_slider) {
		case "s brush size":
			surface_resize(_brush.size_surf, _brush.size, _brush.size);
			surface_resize(_brush.brush_surf, _brush.size, _brush.size);
			input_set_text("brush size", _brush.size);
			break;
		case "s brush falloff":
			input_set_text("brush falloff", _brush.falloff);
			break;
		case "s brush spacing":
			input_set_text("brush spacing", _brush.step_scale);
			break;
		case "s brush weight":
			input_set_text("brush weight", _brush.weight);
			break;
	}
	
	if keyboard_check_pressed(vk_anykey) and _selected_input != "" {
		var t = input_get_text(_selected_input);
		if t != "" and t == string_digits(t) {
			switch(_selected_input) {
				case "brush size":
					_brush.size = clamp(real(t), 1, 200);
					input_set_text("brush size", _brush.size);
					surface_resize(_brush.size_surf, _brush.size, _brush.size);
					surface_resize(_brush.brush_surf, _brush.size, _brush.size);
					break;
				case "brush falloff":
					_brush.falloff = clamp(real(t), 1, 10);
					input_set_text("brush falloff", _brush.falloff);
					break;
				case "brush spacing":
					_brush.step_scale = clamp(real(t), 0.01, 1);
					input_set_text("brush spacing", _brush.step_scale);
					break;
				case "brush weight":
					_brush.weight = clamp(real(t), 0.01, 1);
					input_set_text("brush weight", _brush.weight);
					break;
			}
		}
	}
}

function options_line() {
	
	var xx = 120;
	var yy = 40;
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	
	draw_set_alpha(0.5);
	draw_set_color(c_dkgray);
	draw_rectangle(xx-8, yy, xx+320, yy+80+32, false);
	draw_set_color(c_black);
	draw_rectangle(xx-8, yy, xx+320, yy+80+32, true);
	draw_set_alpha(1);
	
	draw_set_color(c_dkgray);
	draw_rectangle(xx, yy+16, xx+100, yy+32, false);
	draw_rectangle(xx, yy+16+32, xx+100, yy+32+32, false);
	draw_rectangle(xx, yy+16+64, xx+100, yy+32+64, false);
	draw_rectangle(xx+160, yy+16, xx+100+160, yy+32, false);
	draw_rectangle(xx+160, yy+16+32, xx+147+160, yy+32+32, false);
	draw_set_color(c_black);
	draw_rectangle(xx, yy+16, xx+100, yy+32, true);
	draw_rectangle(xx, yy+16+32, xx+100, yy+32+32, true);
	draw_rectangle(xx, yy+16+64, xx+100, yy+32+64, true);
	draw_rectangle(xx+160, yy+16, xx+100+160, yy+32, true);
	draw_rectangle(xx+160, yy+16+32, xx+147+160, yy+32+32, true);
	
	draw_set_color(_line.closed ? c_ltgray : c_dkgray);
	draw_circle(xx+160+130, yy+16+32+8, 13, false);
	draw_set_color(c_black);
	draw_circle(xx+160+130, yy+16+32+8, 13, true);
	
	if point_in_rectangle(mx, my, xx-32, yy-32, xx+320, yy+80+32) _mouse_over_gui = true;
	
	_brush.size = round(min(sqr(h_slider(xx, yy+16, 100, 16, sqrt((_brush.size - 1) / 200), "s brush size", mx, my)) * 200 + 1, 200));
	_brush.falloff = sqr(sqr(h_slider(xx, yy+16+32, 100, 16, sqrt(sqrt((_brush.falloff - 1)/9)), "s brush falloff", mx, my))) * 9 + 1;
	_brush.step_scale = min(h_slider(xx, yy+16+64, 100, 16, _brush.step_scale - 0.01, "s brush spacing", mx, my) + 0.01, 1);
	_line.tension = h_slider(xx+160, yy+16, 100, 16, _line.tension, "s line tension", mx, my);
	if mouse_check_button_pressed(mb_left) and point_in_rectangle(mx, my, xx+160, yy+16+32, xx+147+160, yy+32+32) _line.closed = !_line.closed;
	
	draw_set_colour(c_white);
	draw_set_alpha(0.65);
	draw_set_font(font_open_sans_9);
	draw_text(xx+4, yy+17, _langstr[$ _language].brush_option_size);
	draw_text(xx+4, yy+17+32, _langstr[$ _language].brush_option_falloff);
	draw_text(xx+4, yy+17+64, _langstr[$ _language].brush_option_spacing);
	draw_text(xx+4+160, yy+17, _langstr[$ _language].line_option_tension);
	draw_text(xx+4+160, yy+17+32, _langstr[$ _language].line_option_closed);
	draw_set_alpha(1);
	
	input_draw("brush size", xx+106, yy+12, mx, my);
	input_draw("brush falloff", xx+106, yy+12+32, mx, my);
	input_draw("brush spacing", xx+106, yy+12+64, mx, my);
	input_draw("line tension", xx+106+160, yy+12, mx, my);
	
	if !_line.options_init {
		_line.options_init = true;
		surface_resize(_brush.size_surf, _brush.size, _brush.size);
		surface_resize(_brush.brush_surf, _brush.size, _brush.size);
		input_set_text("brush size", _brush.size);
		input_set_text("brush falloff", _brush.falloff);
		input_set_text("brush spacing", _brush.step_scale);
		input_set_text("line tension", _line.tension);
	}
	
	switch(_selected_slider) {
		case "s brush size":
			surface_resize(_brush.size_surf, _brush.size, _brush.size);
			surface_resize(_brush.brush_surf, _brush.size, _brush.size);
			input_set_text("brush size", _brush.size);
			break;
		case "s brush falloff":
			input_set_text("brush falloff", _brush.falloff);
			break;
		case "s brush spacing":
			input_set_text("brush spacing", _brush.step_scale);
			break;
		case "s line tension":
			input_set_text("line tension", _line.tension);
			break;
	}
	
	if keyboard_check_pressed(vk_anykey) and _selected_input != "" {
		var t = input_get_text(_selected_input);
		if t != "" and t == string_digits(t) {
			switch(_selected_input) {
				case "brush size":
					_brush.size = clamp(real(t), 1, 200);
					input_set_text("brush size", _brush.size);
					surface_resize(_brush.size_surf, _brush.size, _brush.size);
					surface_resize(_brush.brush_surf, _brush.size, _brush.size);
					break;
				case "brush falloff":
					_brush.falloff = clamp(real(t), 1, 10);
					input_set_text("brush falloff", _brush.falloff);
					break;
				case "brush spacing":
					_brush.step_scale = clamp(real(t), 0.01, 1);
					input_set_text("brush spacing", _brush.step_scale);
					break;
				case "line tension":
					_line.tension = clamp(real(t), 0, 1);
					input_set_text("line tension", _line.tension);
					break;
			}
		}
	}
}

function options_fill() {
	
	var xx = 120;
	var yy = 40;
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	
	draw_set_alpha(0.5);
	draw_set_color(c_dkgray);
	draw_rectangle(xx-8, yy, xx+156, yy+16+32, false);
	draw_set_color(c_black);
	draw_rectangle(xx-8, yy, xx+156, yy+16+32, true);
	draw_set_alpha(1);
	
	draw_set_color(c_dkgray);
	draw_rectangle(xx, yy+16, xx+100, yy+32, false);
	draw_set_color(c_black);
	draw_rectangle(xx, yy+16, xx+100, yy+32, true);
	
	if point_in_rectangle(mx, my, xx-32, yy-32, xx+156, yy+16+32) _mouse_over_gui = true;
	
	_fill.tol = round(h_slider(xx, yy+16, 100, 16, _fill.tol/255, "s fill tolerancy", mx, my) * 255);
	
	draw_set_colour(c_white);
	draw_set_alpha(0.65);
	draw_set_font(font_open_sans_9);
	draw_text(xx+4, yy+17, _langstr[$ _language].fill_option_tolerancy);
	draw_set_alpha(1);
	
	input_draw("fill tolerancy", xx+106, yy+12, mx, my);
	
	if !_fill.options_init {
		_fill.options_init = true;
		input_set_text("fill tolerancy", _fill.tol);
	}
	
	switch(_selected_slider) {
		case "s fill tolerancy":
			input_set_text("fill tolerancy", _fill.tol);
			break;
	}
	
	if keyboard_check_pressed(vk_anykey) and _selected_input != "" {
		var t = input_get_text(_selected_input);
		if t != "" and t == string_digits(t) {
			switch(_selected_input) {
				case "fill tolerancy":
					_fill.tol = clamp(real(t), 0, 255);
					input_set_text("fill tolerancy", _fill.tol);
					break;
			}
		}
	}
}

function options_area() {
	
	var xx = 120;
	var yy = 40;
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	
	var w = _area_select.mode == 2 ? 156 : 112;
	var h = _area_select.mode == 2 ? 60 : 32;
	
	draw_set_alpha(0.5);
	draw_set_color(c_dkgray);
	draw_rectangle(xx-8, yy, xx+w, yy+16+h, false);
	draw_set_color(c_black);
	draw_rectangle(xx-8, yy, xx+w, yy+16+h, true);
	draw_set_alpha(1);
	
	for(var i = 0; i < 3; i++) {
		var c = _area_select.mode == i ? c_lime : c_white;
		if mouse_check_button_pressed(mb_left) and point_in_rectangle(mx, my, xx+i*36, yy+24-16, xx+i*36+32, yy+24+16) _area_select.mode = i;
		draw_sprite_ext(spr_toolbar_icon_ramecek, 0, xx+16+i*36, yy+24, 1, 1, 0, c, 1);
		draw_sprite_ext(spr_area_select_opt, i, xx+16+i*36, yy+24, 1, 1, 0, c, 1);
	}
	
	if point_in_rectangle(mx, my, xx-8, yy, xx+w, yy+16+h) _mouse_over_gui = true;
	
	if !_area_select.options_init {
		_area_select.options_init = true;
		surface_resize(_brush.size_surf, _brush.size, _brush.size);
		surface_resize(_brush.brush_surf, _brush.size, _brush.size);
		input_set_text("brush size", _brush.size);
	}
	

	if _area_select.mode == 2 {
	
		draw_set_color(c_dkgray);
		draw_rectangle(xx, yy+16+32, xx+100, yy+32+32, false);
		draw_set_color(c_dkgray);
		draw_rectangle(xx, yy+16+32, xx+100, yy+32+32, true);
	
		_brush.size = round(min(sqr(h_slider(xx, yy+16+32, 100, 16, sqrt((_brush.size - 1) / 200), "s brush size", mx, my)) * 200 + 1, 200));
	
		input_draw("brush size", xx+106, yy+12+32, mx, my);
	
		draw_set_colour(c_white);
		draw_set_alpha(0.65);
		draw_set_font(font_open_sans_9);
		draw_text(xx+4, yy+17+32, _langstr[$ _language].brush_option_size);
		draw_set_alpha(1);

		switch(_selected_slider) {
			case "s brush size":
				surface_resize(_brush.size_surf, _brush.size, _brush.size);
				surface_resize(_brush.brush_surf, _brush.size, _brush.size);
				input_set_text("brush size", _brush.size);
				break;
		}
	
		if keyboard_check_pressed(vk_anykey) and _selected_input != "" {
			var t = input_get_text(_selected_input);
			if t != "" and t == string_digits(t) {
				switch(_selected_input) {
					case "brush size":
						_brush.size = clamp(real(t), 1, 200);
						input_set_text("brush size", _brush.size);
						surface_resize(_brush.size_surf, _brush.size, _brush.size);
						surface_resize(_brush.brush_surf, _brush.size, _brush.size);
						break;
				}
			}
		}
	}
}
