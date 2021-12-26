function surf2buff(s) {
	var size = (surface_get_width(s) * surface_get_height(s)) * 4;
	var b = buffer_create(size, buffer_fast, 1);
	buffer_get_surface(b, s, 0);
	return b;
}

function buff_get_pixel(buff, x, y, w, h) {

	if x >= w or y >= h return [0, 0, 0, 0];
	
	var pos = 4 * (x + (y * w));
	
	return [
		buffer_peek(buff, pos, buffer_u8),
		buffer_peek(buff, pos+1, buffer_u8),
		buffer_peek(buff, pos+2, buffer_u8),
		buffer_peek(buff, pos+3, buffer_u8)
	];
}

function buff_set_pixel(buff, x, y, w, col) {
	
	var pos = 4 * (x + (y * w));
	buffer_poke(buff, pos, buffer_u8, col[0]);
	buffer_poke(buff, pos+1, buffer_u8, col[1]);
	buffer_poke(buff, pos+2, buffer_u8, col[2]);
	buffer_poke(buff, pos+3, buffer_u8, col[3]);
}
