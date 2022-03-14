function draw_layer_select(x, y) {
	
	_layer_select.surf = check_surf(_layer_select.surf, _layer_select.w, _layer_select.h, c_dkgray, 1);
	
	var ww = _layer_select.w;
	var wh = _layer_select.h;
	
	var base = 64;
	var imgw = base;
	var imgh = base;
	var ratio = _paper_res.w / _paper_res.h;
	
	var row_h = base + 10;
	
	if ratio < 1 imgw = base * ratio;
	else imgh = base / ratio;
	
	var bpw = (base+imgw)/2;
	var bmw = (base-imgw)/2;
	var bph = (base+imgh)/2;
	var bmh = (base-imgh)/2;
	
	var can_scroll = row_h * ds_list_size(_layers) > wh;
	
	if point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x+ww, y+wh) {
		_mouse_over_gui = true;
		if can_scroll _layer_select.ypos += (mouse_wheel_down() - mouse_wheel_up()) * row_h/2;
	}
	else if point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y+wh, x+ww, y+wh+32) {
		_mouse_over_gui = true;
	}
	
	surface_set_target(_layer_select.surf);
	draw_clear(c_dkgray);
	
	foreach ["i","l"] in _layers as_list {
		
		var xx = 5;
		var yy = 5 + _layer_select.ypos_smooth + row_h * (ds_list_size(_layers)-1 - i);
		
		if point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x+xx, y+yy-4, x+xx+base+4, y+yy+base+5) 
		and point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x+ww, y+wh)
		and !_mouse_started_on_paper {
			
			draw_set_color(make_color_rgb(0, 150, 0));
			draw_rectangle(xx-2, yy-2, xx+_layer_select.w-9, yy+base+2, false);
			
			if mouse_check_button_pressed(mb_left) {
				_current_layer = i;
			}
		}
		else if _current_layer == i {
			draw_set_color(make_color_rgb(0, 120, 0));
			draw_rectangle(xx-2, yy-2, xx+_layer_select.w-9, yy+base+2, false);
		}
		
		draw_sprite_part(spr_bkg_squares, 1, 0, 0, imgw, imgh, xx+bmw, yy+bmh);
		draw_surface_stretched(l.s, xx+bmw, yy+bmh, imgw, imgh);
		
		if (mouse_check_button(mb_left) and _current_layer == i) or _current_tool == _tool.line
			draw_surface_stretched(_alpha_surf, xx+bmw, yy+bmh, imgw, imgh);
		
		if point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x+xx+base+10, y+yy+34, x+xx+base+10+20, y+yy+34+20) {
			
			draw_set_color(c_gray);
			draw_rectangle(xx+base+10+1, yy+34+1, xx+base+10+20-2, yy+34+20-2, false);
			
			if mouse_check_button_pressed(mb_left) l.hidden = !l.hidden;
		}
		
		gpu_set_tex_filter(true);
		draw_sprite_ext(spr_alpha, 2, xx+base+45+74, yy+32+3, 1.1, 0.82, -90, c_white, 1);
		
		l.layer_alpha = (round((h_slider(xx+base+37, yy+32+1, 82, 20, l.layer_alpha, 
			"L_ALPHA"+string(l.l_id), device_mouse_x_to_gui(0)-x, device_mouse_y_to_gui(0)-y)*255)/5)*5)/255;
		
		draw_set_color(c_dkgray);
		draw_set_font(font_open_sans_9)
		draw_set_halign(1);
		draw_text(xx+base+37+41, yy+36, round(l.layer_alpha * 255));
		draw_set_halign(0);
		gpu_set_tex_filter(false);
		
		draw_sprite(spr_layer_visibility, real(l.hidden), xx+base+10, yy+34);
		
		var inp = "L_NAME_"+string(l.l_id);
		input_draw(inp, xx+base+10, yy+4, device_mouse_x_to_gui(0)-x, device_mouse_y_to_gui(0)-y);
		l.name = input_get_text(inp);
		
		draw_set_color(c_black);
		draw_rectangle(xx+bmw, yy+bmh, xx+bpw-1, yy+bph-1, true);
	}
	
	if can_scroll _layer_select.ypos = clamp(_layer_select.ypos, wh - row_h * ds_list_size(_layers), 0);
	else _layer_select.ypos = 0;
	
	_layer_select.ypos_smooth = lerp(_layer_select.ypos_smooth, _layer_select.ypos, 0.2);
	
	surface_reset_target();
	draw_surface(_layer_select.surf, x, y);
	
	if !_mouse_started_on_paper and point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y+wh, x+32, y+wh+32) {
		draw_set_color(make_color_rgb(25, 200, 25));
		draw_rectangle(x, y+wh, x+32, y+wh+32, false);
		if mouse_check_button_pressed(mb_left) layer_add(c_black, 0);
	}
	else {
		draw_set_color(make_color_rgb(50, 100, 50));
		draw_rectangle(x, y+wh, x+32, y+wh+32, false);
	}
	
	if !_mouse_started_on_paper and point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x+32, y+wh, x+32*2, y+wh+32) {
		draw_set_color(make_color_rgb(150, 25, 25));
		draw_rectangle(x+32, y+wh, x+32*2, y+wh+32, false);
		if mouse_check_button_pressed(mb_left) and _current_layer > -1 layer_delete(_current_layer--);
	}
	else {
		draw_set_color(make_color_rgb(75, 50, 50));
		draw_rectangle(x+32, y+wh, x+32*2, y+wh+32, false);
	}
	
	if !_mouse_started_on_paper and point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x+32*2, y+wh, x+32*3, y+wh+32) {
		draw_set_color(make_color_rgb(100, 100, 200));
		draw_rectangle(x+32*2, y+wh, x+32*3, y+wh+32, false);
		if mouse_check_button_pressed(mb_left) and _current_layer > 0 layer_join_below(_current_layer--);
	}
	else {
		draw_set_color(make_color_rgb(50, 50, 100));
		draw_rectangle(x+32*2, y+wh, x+32*3, y+wh+32, false);
	}
	
	if !_mouse_started_on_paper and point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x+32*3, y+wh, x+32*4, y+wh+32) {
		draw_set_color(make_color_rgb(100, 100, 200));
		draw_rectangle(x+32*3, y+wh, x+32*4, y+wh+32, false);
		if mouse_check_button_pressed(mb_left) and ds_list_size(_layers) > 1 {
			layer_join_all();
			_current_layer = 0;
		}
	}
	else {
		draw_set_color(make_color_rgb(50, 50, 100));
		draw_rectangle(x+32*3, y+wh, x+32*4, y+wh+32, false);
	}
	
	draw_sprite(spr_layer_icons, 0, x, y+wh);
	draw_sprite(spr_layer_icons, 1, x+32, y+wh);
	draw_sprite(spr_layer_icons, 2, x+32*2, y+wh);
	draw_sprite(spr_layer_icons, 3, x+32*3, y+wh);
}
