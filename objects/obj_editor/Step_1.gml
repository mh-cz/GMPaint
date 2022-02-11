if window_get_width() != screen.w or window_get_height() != screen.h {
	if window_get_height() > 10 {
		window_resize();
		alarm[0] = ceil(room_speed * 0.25) + 1;
	}
	else alarm[0] = ceil(room_speed * 0.35) + 1;
}
