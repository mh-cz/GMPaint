function draw_bottom_bar() {
	draw_set_color(c_dkgray);
	draw_rectangle(0, screen.h - _bottom_bar.h, screen.w, screen.h, false);
	
	draw_set_color(c_black);
	draw_line(0, screen.h - _bottom_bar.h, screen.w, screen.h - _bottom_bar.h);
}
