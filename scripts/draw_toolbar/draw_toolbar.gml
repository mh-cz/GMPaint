function draw_toolbar(x, y, max_xc) {
	
	gpu_set_tex_filter(true);
	
	var xc = 0;
	var yc = 0;
	
	for(var i = 0; i < sprite_get_number(spr_toolbar_icons); i++) {
		
		var xx = x + 36*xc;
		var yy = y + 36*yc;
		
		var pds = point_distance(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), xx, yy);
		
		var s = pds < 120 and !_mouse_over_menu and !_mouse_started_on_paper ? clamp((120 - pds) * 0.011, 1, 1.2) : 1;
		var c = _current_tool == i ? c_lime : c_white;
		
		draw_sprite_ext(spr_toolbar_icon_ramecek, i, xx, yy, s, s, 0, c, 0.75);
		draw_sprite_ext(spr_toolbar_icons, i, xx, yy, s, s, 0, c, 1);
		
		if point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), xx-18, yy-18, xx+18, yy+18) {
			_mouse_over_gui = true;
			
			if device_mouse_check_button_pressed(0, mb_left) and !_mouse_over_menu {
				on_switch_tool(i);
				_current_tool = i;
			}
		}
		
		if ++xc > max_xc-1 {
			yc++;
			xc = 0;
		}
	}
	
	gpu_set_tex_filter(false);
}
