function draw_text_outlined(x, y, str, c = c_white, oc = c_black, w = 1) {
	
	draw_set_color(oc);
	draw_text(x+w, y+w, str);
	draw_text(x+w, y-w, str);
	draw_text(x-w, y+w, str);
	draw_text(x-w, y-w, str);
	
	draw_set_color(c);
	draw_text(x, y, str);
}
