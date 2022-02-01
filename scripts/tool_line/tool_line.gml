function line_curve(points_list, tension, closed) {

	var ps = [];
	var points_len = ds_list_size(points_list);
	
	if points_len < 2 return;
	
	if !closed {
		for(var i = 0; i < points_len + 1; i++) {
			if i == 0 ps[array_length(ps)] = points_list[| i];
			if i < points_len ps[array_length(ps)] = points_list[| i];
			else ps[array_length(ps)] = points_list[| points_len-1];
		}
	}
	else {
		for(var i = 0; i < points_len + 1; i++) {
			if i == 0 ps[array_length(ps)] = points_list[| points_len-1];
			if i < points_len ps[array_length(ps)] = points_list[| i];
			else {
				ps[array_length(ps)] = points_list[| 0];
				ps[array_length(ps)] = points_list[| 1];
			}
		}
	}
	
	for(var i = 1; i < array_length(ps) - 2; i++) {
	    var p0 = ps[i - 1];
	    var p1 = ps[i];
	    var p2 = ps[i + 1];
	    var p3 = ps[i + 2];
		
		var m1x = (1 - tension) * (p2[0] - p1[0] + ((p1[0] - p0[0]) / 1 - (p2[0] - p0[0]) * 0.5));
		var m2x = (1 - tension) * (p2[0] - p1[0] + ((p3[0] - p2[0]) / 1 - (p3[0] - p1[0]) * 0.5));
		var m1y = (1 - tension) * (p2[1] - p1[1] + ((p1[1] - p0[1]) / 1 - (p2[1] - p0[1]) * 0.5));
		var m2y = (1 - tension) * (p2[1] - p1[1] + ((p3[1] - p2[1]) / 1 - (p3[1] - p1[1]) * 0.5));
		
	    var ax = 2 * p1[0] - 2 * p2[0] + m1x + m2x;
	    var ay = 2 * p1[1] - 2 * p2[1] + m1y + m2y;
	    var bx = -3 * p1[0] + 3 * p2[0] - 2 * m1x - m2x;
	    var by = -3 * p1[1] + 3 * p2[1] - 2 * m1y - m2y;
	    var cx = m1x;
	    var cy = m1y;
	    var dx = p1[0];
	    var dy = p1[1];
		
		var amount = 25;
		var prevx = dx;
		var prevy = dy;
	    for(var j = 1; j <= amount; j++) {
	        var t = j / amount;
	        var px = ax * t * t * t + bx * t * t + cx * t + dx;
	        var py = ay * t * t * t + by * t * t + cy * t + dy;
			
			var pdr = point_direction(prevx, prevy, px, py);
			var pds = point_distance(prevx, prevy, px, py);
			for(var k = 0; k < pds; k += _brush.step) {
				draw_surface(_brush.predraw_surf,
					prevx - _brush.size/2 + lengthdir_x(k, pdr),
					prevy - _brush.size/2 + lengthdir_y(k, pdr));
			}
			
			prevx = px;
			prevy = py;
	    }
	}
}

function line_circle_intersection(x1, y1, x2, y2, cx, cy, rad) {
	
	var ac1 = cx - x1;
	var ac2 = cy - y1;
	var ab1 = x2 - x1;
	var ab2 = y2 - y1;
	
    var abab = dot_product(ab1, ab2, ab1, ab2);
    var acab = dot_product(ac1, ac2, ab1, ab2);
    var t = clamp(acab/abab, 0, 1);

    var h1 = ab1 * t + x1 - cx;
	var h2 = ab2 * t + y1 - cy;
	
    return dot_product(h1, h2, h1, h2) <= rad * rad
}

function draw_circle_ext(x, y, r, w, s) {
	
	var step = 360/s;
	draw_primitive_begin(pr_trianglestrip);
	for (var i = 0; i <= 360; i += step)
	{
	    draw_vertex(x+lengthdir_x(r, i), y+lengthdir_y(r, i));
	    draw_vertex(x+lengthdir_x(r+w, i), y+lengthdir_y(r+w, i));
	}
	draw_primitive_end();
}

function tool_line() {
	
	var list = _line.points_list;
	var mouse_over_point = -1;
	var line_mouse_col = -1;
	var points_len = ds_list_size(list);
	
	gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
	
	surface_set_target(_brush.predraw_surf);
	draw_clear_alpha(c_black, 0);
	shader_set(shd_brush);
	shader_set_uniform_f(shader_get_uniform(shd_brush, "fo"), _brush.falloff);
	shader_set_uniform_f(shader_get_uniform(shd_brush, "fo_a"), 1);
	draw_surface(_brush.size_surf, 0, 0);
	shader_reset();
	surface_reset_target();
	
	surface_set_target(_mask_surf);
	draw_clear_alpha(c_black, 0);
	line_curve(list, _line.tension, _line.closed);
	surface_reset_target();
	
	surface_set_target(_draw_surf);
	draw_clear_alpha(c_black, 0);
	draw_surface(_mask_surf, 0, 0);
	gpu_set_blendmode(bm_normal);
	gpu_set_colorwriteenable(true, true, true, false);
	draw_sprite_stretched_ext(spr_1px, 0, 0, 0, _resolution.w, _resolution.h, rgba2c(_brush.col, 255), 1);
	gpu_set_colorwriteenable(true, true, true, true);
	gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
	surface_reset_target();
			
	surface_set_target(_alpha_surf);
	draw_clear_alpha(c_black, 0);
	draw_surface_ext(_draw_surf, 0, 0, 1, 1, 0, c_white, clamp(_brush.col[3] * 1.5, 0, 1));
	surface_reset_target();
	
	if keyboard_check_pressed(vk_enter) {
			
		surface_set_target(_layers[| _current_layer].s);
		shader_set(shd_premultiply_alpha);
		draw_surface(_alpha_surf, 0, 0);
		shader_reset();
		surface_reset_target();
			
		clear_surf([_mask_surf, _draw_surf, _alpha_surf]);
		ds_list_clear(list);
		points_len = 0;
		_line.grabbed = -1;
		
		save_layer(_current_layer);
	}
	
	gpu_set_blendmode(bm_normal);
	
	#region      /////////////////      DRAW      /////////////////

	for(var i = 0; i < ds_list_size(_layers); i++) {
		var layer_data = _layers[| i];
		layer_data.s = check_surf(layer_data.s, _resolution.w, _resolution.h, layer_data.c, layer_data.a);
	
		gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
		draw_surface_stretched(layer_data.s, 0, 0, _resolution.w, _resolution.h);
		gpu_set_blendmode(bm_normal);
	}

	draw_set_color(c_dkgray);
	draw_rectangle(0, 0, _resolution.w - 1, _resolution.h - 1, true);

	draw_surface_stretched(_alpha_surf, 0, 0, _resolution.w, _resolution.h);
	
	if points_len == 0 {
		gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
		draw_surface_ext(_brush.predraw_surf, _brush.wmx - _brush.size/2, _brush.wmy - _brush.size/2, 
							1, 1, 0, rgba2c(_brush.col, 255), clamp(_brush.col[3], 0, 1));
		gpu_set_blendmode(bm_normal);
	}
	
	draw_set_color(c_dkgray);
	draw_circle(_brush.wmx-1, _brush.wmy-1, _brush.size/2 - 1, true);
	draw_set_color(c_white);
	
	#endregion
	
	var zm = _zoom * 1.5;
	
	if !_mouse_over_gui {
		for(var i = 0; i < points_len; i++) {
			var pos = list[| i];
			if point_distance(mouse_x-1, mouse_y-1, pos[0], pos[1]) < max(1, 10 * zm) {
				mouse_over_point = i;
				break;
			}
		}
	}
	
	if _line.closed and points_len > 2 {
		var prev_pos = list[| points_len-1];
		var this_pos = list[| 0];
		
		if mouse_over_point == -1 and line_mouse_col == -1 and !_mouse_over_gui
			if line_circle_intersection(prev_pos[0], prev_pos[1], this_pos[0], this_pos[1], mouse_x-1, mouse_y-1, max(0.75, 8 * zm)) {
				line_mouse_col = i;
		}
		
		var wid = line_mouse_col == i ? 2.5 : 1.5;
		
		draw_set_color(c_black);
		draw_line_width(prev_pos[0], prev_pos[1], this_pos[0], this_pos[1], (wid + 2.5) * zm);
		draw_set_color(c_white);
		draw_line_width(prev_pos[0], prev_pos[1], this_pos[0], this_pos[1], wid * zm);
	}
	
	for(var i = 1; i < points_len+1; i++) {
		
		var prev_pos = list[| i-1];
		var this_pos = list[| i];
			
		if i > points_len-1 this_pos = prev_pos;
			
		if mouse_over_point == -1 and line_mouse_col == -1 and !_mouse_over_gui
			if line_circle_intersection(prev_pos[0], prev_pos[1], this_pos[0], this_pos[1], mouse_x-1, mouse_y-1, max(0.75, 8 * zm)) {
				line_mouse_col = i;
		}
		
		var plus = mouse_over_point == i-1 ? 2 : 0;
		var wid = line_mouse_col == i ? 2.5 : 1.5;
		
		draw_set_color(c_black);
		draw_line_width(prev_pos[0], prev_pos[1], this_pos[0], this_pos[1], (wid + 2.5) * zm);
		draw_set_color(c_white);
		draw_line_width(prev_pos[0], prev_pos[1], this_pos[0], this_pos[1], wid * zm);
		
		draw_set_color(c_black);
		draw_circle_ext(prev_pos[0]+1, prev_pos[1]+1, (3.5 + plus) * zm, 2 * zm, 32);
		draw_set_color(c_white);
		draw_circle_ext(prev_pos[0]+1, prev_pos[1]+1, (2.5 + plus) * zm, 1 * zm, 32);
	}
	
	if !_mouse_over_gui {
		
		if device_mouse_check_button_pressed(0, mb_right) {
			ds_list_delete(list, mouse_over_point);
		}
	
		if device_mouse_check_button_pressed(0, mb_left) {
		
			if line_mouse_col != -1 and mouse_over_point == -1 {
				ds_list_insert(list, line_mouse_col, [mouse_x-1, mouse_y-1]);
				_line.grabbed = line_mouse_col;
			}
			else if mouse_over_point == -1 {
				ds_list_add(list, [mouse_x-1, mouse_y-1]);
				_line.grabbed = points_len;
			}
			else if mouse_over_point != -1 {
				_line.grabbed = mouse_over_point;
			}
		}
	
		if device_mouse_check_button(0, mb_left) and _line.grabbed != -1 {
			ds_list_replace(list, _line.grabbed, [mouse_x-1, mouse_y-1]);
		
			if points_len == 1 and _brush.moved and _line.grabbed == 0 {
				ds_list_add(list, [mouse_x-1, mouse_y-1]);
				_line.grabbed = points_len;
			}
		}
		else {
			_line.grabbed = -1;
		}
	}
	else {
		_line.grabbed = -1;
	}
}


