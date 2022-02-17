function draw_bottom_bar() {
	draw_set_color(c_dkgray);
	draw_rectangle(0, screen.h - _bottom_bar.h, screen.w, screen.h, false);
	
	draw_set_color(c_black);
	draw_line(0, screen.h - _bottom_bar.h, screen.w, screen.h - _bottom_bar.h);
	
	if point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), 0, screen.h - _bottom_bar.h, screen.w, screen.h)
		_mouse_over_gui = true;
}
function draw_upper_bar() {
	draw_set_color(c_dkgray);
	draw_rectangle(0, 0, screen.w, _upper_bar.h, false);
	
	draw_set_color(c_black);
	draw_line(0, _upper_bar.h, screen.w, _upper_bar.h);
	
	if point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), 0, 0, screen.w, _upper_bar.h)
		_mouse_over_gui = true;
}
