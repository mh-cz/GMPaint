function draw_bottom_bar() {
	draw_set_color(c_dkgray);
	draw_rectangle(0, screen.h - _bottom_bar.h, screen.w, screen.h, false);
	
	draw_set_color(c_black);
	draw_line(0, screen.h - _bottom_bar.h, screen.w, screen.h - _bottom_bar.h);
	
	if point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), 0, screen.h - _bottom_bar.h, screen.w, screen.h)
		_mouse_over_gui = true;
	
	draw_set_font(font_open_sans_11);
	draw_set_color(c_white);
	
	if _bottom_bar.rt_time-- > 0 {
		draw_set_halign(2);
		draw_text(screen.w-16, screen.h-20, _bottom_bar.right_text);
		draw_set_halign(0);
	}
	if _bottom_bar.lt_time-- > 0 {
		draw_text(16, screen.h-20, _bottom_bar.left_text);
	}
}

function set_bottom_right_text(str, sec) {
	_bottom_bar.rt_time = sec * room_speed;
	_bottom_bar.right_text = str;
}
function set_bottom_left_text(str, sec) {
	_bottom_bar.lt_time = sec * room_speed;
	_bottom_bar.left_text = str;
}

function draw_upper_bar() {
	draw_set_color(c_dkgray);
	draw_rectangle(0, 0, screen.w, _upper_bar.h, false);
	
	draw_set_color(c_black);
	draw_line(0, _upper_bar.h, screen.w, _upper_bar.h);
	
	if point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), 0, 0, screen.w, _upper_bar.h)
		_mouse_over_gui = true;
}
