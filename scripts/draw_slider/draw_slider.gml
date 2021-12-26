function draw_slider(SLIDER_MAP, slider_id, pos_x, pos_y, sprite_first, sprite_mid, sprite_last, sprite_rider, snaps, scale) {
	
	if !ds_map_exists(SLIDER_MAP, "$ID") SLIDER_MAP[? "$ID"] = undefined; // init selected slider if not done already
	if !ds_map_exists(SLIDER_MAP, slider_id) SLIDER_MAP[? slider_id] = [0, 0, 0]; // init defaults for this slider_id if not already created [rider_x, 0-1, snap], can be done manually
	
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	
	scale = max(scale, 0.001);
	
	var line_w = sprite_get_width(sprite_mid) * scale;
	var rider_w = sprite_get_width(sprite_first) * scale;
	var hitbox_h = max(sprite_get_height(sprite_mid) * scale, rider_w);
	
	pos_x += sprite_get_width(sprite_first) * scale;
	pos_y += round(hitbox_h / 2);
	
	if snaps < 2 or snaps > line_w snaps = line_w;

	var selected_id = SLIDER_MAP[? "$ID"];
	
	if device_mouse_check_button_pressed(0, mb_left) and selected_id == undefined
	and point_in_rectangle(mx, my, pos_x - rider_w, pos_y - hitbox_h/2, pos_x + rider_w + line_w, pos_y + hitbox_h/2)
		SLIDER_MAP[? "$ID"] = slider_id;
		
	if device_mouse_check_button_released(0, mb_left) and selected_id != undefined SLIDER_MAP[? "$ID"] = undefined;
	
	var rider_x = SLIDER_MAP[? slider_id][0];
	
	if selected_id == slider_id {

		var snap_size = line_w / clamp(--snaps, 1, line_w);
		rider_x = clamp(round((mx - pos_x) / snap_size) * snap_size, 0, line_w);
		
		SLIDER_MAP[? slider_id] = [rider_x, rider_x / line_w, floor(rider_x / snap_size)];
	}
	
	var alpha = draw_get_alpha();
	var col = draw_get_color();
	
	draw_sprite_ext(sprite_first, 0, pos_x, pos_y, scale, scale, 0, col, alpha); // first part
	draw_sprite_ext(sprite_mid, 0, pos_x, pos_y, scale, scale, 0, col, alpha); // middle part
	draw_sprite_ext(sprite_last, 0, pos_x + line_w, pos_y, scale, scale, 0, col, alpha); // last part
	draw_sprite_ext(sprite_rider, 0, pos_x + rider_x, pos_y, scale, scale, 0, col, alpha); // rider
}