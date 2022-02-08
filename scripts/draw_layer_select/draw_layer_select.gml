function draw_layer_select(x, y) {
	
	_layer_select.surf = check_surf(_layer_select.surf, _layer_select.w, _layer_select.h, c_dkgray, 1);
	
	var ww = _layer_select.w;
	var wh = _layer_select.h;
	
	var base = 64;
	var imgw = base;
	var imgh = base;
	var ratio = _paper_res.w / _paper_res.h;
	
	if ratio < 1 imgw = base * ratio;
	else imgh = base / ratio;
	
	if point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x+ww, y+wh)
		_mouse_over_gui = true;
	
	surface_set_target(_layer_select.surf);
	draw_clear(c_dkgray);
	
	for(var i = 0; i < ds_list_size(_layers); i++) {
		
		var xx = 5;
		var yy = 5 + _layer_select.ypos + (base + 10) * i;
		
		if point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x+xx, y+yy, x+xx+_layer_select.w-10, y+yy+base-1) {
									
			draw_set_color(make_color_rgb(0,170,0));
			draw_rectangle(xx-2, yy-2, xx+_layer_select.w-9, yy+base+2, false);
			
			if mouse_check_button_pressed(mb_left) {
				_current_layer = i;
			}
		}
		
		draw_sprite(spr_bkg_squares, 1, xx, yy);
		draw_surface_stretched(_layers[| i].s, xx + base/2 - imgw/2, yy + base/2 - imgh/2, imgw, imgh);
		if mouse_check_button(mb_left)
			draw_surface_stretched(_alpha_surf, xx + base/2 - imgw/2, yy + base/2 - imgh/2, imgw, imgh);
		
		input_draw("LNAME_"+string(_layers[| i].l_id), )
	}
	
	surface_reset_target();
	draw_surface(_layer_select.surf, x, y);
}
