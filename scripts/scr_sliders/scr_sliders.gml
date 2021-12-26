function v_slider(x1, y1, w, h, val, s_id) {
	
	var x2 = x1 + w;
	var y2 = y1 + h;
	
	var newval = val;
	
	if _selected_slider == s_id {
			newval = clamp((device_mouse_y_to_gui(0) - y1) / abs(y1 - y2), 0, 1);
	}
	else if mouse_check_button_pressed(mb_left) 
	and point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x1, y1, x2, y2) {
		_selected_slider = s_id;
	}
	
	draw_sprite_ext(spr_slider_rider, 0, x1 + h/2, y1 + abs(y1 - y2) * newval, 1, 1, 0, c_white, 1);
		
	return 1 - clamp(newval, 0, 1);
}

function h_slider(x1, y1, w, h, val, s_id) {
	
	var x2 = x1 + w;
	var y2 = y1 + h;
	var newval = val;
	
	if _selected_slider == s_id {
			newval = clamp((device_mouse_x_to_gui(0) - x1) / abs(x1 - x2), 0, 1);
	}
	else if mouse_check_button_pressed(mb_left) 
	and point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x1, y1, x2, y2) {
		_selected_slider = s_id;
	}
		
	draw_sprite_ext(spr_slider_rider, 0, x1 + abs(x1 - x2) * newval, y1 + h/2 + 1, 1, 1, 90, c_white, 1);
		
	return clamp(newval, 0, 1);
}
