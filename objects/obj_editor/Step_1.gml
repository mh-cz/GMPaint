if window_get_width() != screen.w or window_get_height() != screen.h {
	window_resize();
	alarm[0] = floor(room_speed * 0.25) + 1;
}
