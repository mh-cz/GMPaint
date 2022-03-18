function area_copy() {
	
	var buf = buffer_create(_paper_res.w * _paper_res.h * 4, buffer_fixed, 1);
	buffer_seek(buf, buffer_seek_start, 0);
	buffer_get_surface(buf, _area_surf, 0);
	
	_area_select.mx = [0, 0];
	_area_select.mn = [_paper_res.w, _paper_res.h];
	
	for(var w = 0; w < _paper_res.w-1; w++) {
		for(var h = 0; h < _paper_res.h-1; h++) {
			
			if buffer_peek(buf, 4 * (h * _paper_res.w + w) + 3, buffer_fast) != 0 {
				_area_select.mn = [min(_area_select.mn[0], w), min(_area_select.mn[1], h)];
				_area_select.mx = [max(_area_select.mx[0], w), max(_area_select.mx[1], h)];
			}
		}
	}
	
	buffer_delete(buf);
	
	_area_select.copy_surf_size = [_area_select.mx[0] - _area_select.mn[0], _area_select.mx[1] - _area_select.mn[1]];
	
	if _area_select.copy_surf_size[0] == 0 or _area_select.copy_surf_size[1] == 0 return 0;
	
	surface_resize(_copy_surf, _area_select.copy_surf_size[0], _area_select.copy_surf_size[1]);
	
	surface_set_target(_copy_surf);
	draw_clear_alpha(c_black, 0);
	shader_set(shd_limit_to_area);
	texture_set_stage(shader_get_sampler_index(shd_limit_to_area, "area"), surface_get_texture(_area_surf));
	draw_surface(_layers[| _current_layer].s, -_area_select.mn[0], -_area_select.mn[1]);
	shader_reset();
	surface_reset_target();
}

function area_paste() {
	_pasted_selection.active = true;
	_pasted_selection.pos = [_mouse.x, _mouse.y];
	_pasted_selection.size = [_area_select.copy_surf_size[0], _area_select.copy_surf_size[1]];
	_pasted_selection.rot = 0;
	_pasted_selection.placed = false;
	clear_area_select();
}

function pasted_selection() {
	
	var ps = _pasted_selection;
	var h = [0,0,0,0,0,0,0,0];
	
	var corner2center_angle = point_direction(0, 0, ps.size[0]/2, ps.size[1]/2);
	var corner2center_dist = point_distance(0, 0, ps.size[0]/2, ps.size[1]/2);
	
	gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
	
	surface_set_target(_draw_surf);
	draw_clear_alpha(c_black, 0);
	
	if !ps.placed {
		
		ps.pos = [_mouse.x - round(ps.size[0]/2), _mouse.y - round(ps.size[1]/2)];
		draw_surface(_copy_surf, ps.pos[0], ps.pos[1]);		
		
		if mouse_check_button_released(mb_left) and !_mouse_over_gui ps.placed = true;
	}
	else {
		draw_surface_general(_copy_surf, 0, 0, _area_select.copy_surf_size[0], _area_select.copy_surf_size[1],
			(ps.pos[0] - lengthdir_x(corner2center_dist, corner2center_angle + ps.rot)) + ps.size[0]/2,
			(ps.pos[1] - lengthdir_y(corner2center_dist, corner2center_angle + ps.rot)) + ps.size[1]/2,
			ps.size[0]/_area_select.copy_surf_size[0], ps.size[1]/_area_select.copy_surf_size[1], ps.rot, 
			c_white, c_white, c_white, c_white, 1);
	}
	
	surface_reset_target();
	
	if ps.placed {
		
		if !mouse_check_button(mb_left) {
			
			ps.action = 0;
			
			var r = max(1, 10 * _zoom * 1.5);
			
			if point_distance(ps.pos[0], ps.pos[1], _mouse.x, _mouse.y) < r {
				ps.mpos = [_mouse.x, _mouse.y];
				ps.action = 3.1;
			}
			else if point_distance(ps.pos[0]+ps.size[0]/2, ps.pos[1], _mouse.x, _mouse.y) < r {
				ps.mpos = [_mouse.x, _mouse.y];
				ps.action = 3.2;
			}
			else if point_distance(ps.pos[0]+ps.size[0], ps.pos[1], _mouse.x, _mouse.y) < r {
				ps.mpos = [_mouse.x, _mouse.y];
				ps.action = 3.3;
			}
			else if point_distance(ps.pos[0]+ps.size[0], ps.pos[1]+ps.size[1]/2, _mouse.x, _mouse.y) < r {
				ps.mpos = [_mouse.x, _mouse.y];
				ps.action = 3.4;
			}
			else if point_distance(ps.pos[0]+ps.size[0], ps.pos[1]+ps.size[1], _mouse.x, _mouse.y) < r {
				ps.mpos = [_mouse.x, _mouse.y];
				ps.action = 3.5;
			}
			else if point_distance(ps.pos[0]+ps.size[0]/2, ps.pos[1]+ps.size[1], _mouse.x, _mouse.y) < r {
				ps.mpos = [_mouse.x, _mouse.y];
				ps.action = 3.6;
			}
			else if point_distance(ps.pos[0], ps.pos[1]+ps.size[1], _mouse.x, _mouse.y) < r {
				ps.mpos = [_mouse.x, _mouse.y];
				ps.action = 3.7;
			}
			else if point_distance(ps.pos[0], ps.pos[1]+ps.size[1]/2, _mouse.x, _mouse.y) < r {
				ps.mpos = [_mouse.x, _mouse.y];
				ps.action = 3.8;
			}
			else if point_in_rectangle(_mouse.x, _mouse.y, 
			min(ps.pos[0], ps.pos[0]+ps.size[0]), min(ps.pos[1], ps.pos[1]+ps.size[1]),
			max(ps.pos[0], ps.pos[0]+ps.size[0]), max(ps.pos[1], ps.pos[1]+ps.size[1])) {
				ps.mpos = [_mouse.x, _mouse.y];
				ps.action = 1;
			}
			else if point_in_rectangle(_mouse.x, _mouse.y, 
			min(ps.pos[0], ps.pos[0]+ps.size[0])-32, min(ps.pos[1], ps.pos[1]+ps.size[1])-32,
			max(ps.pos[0], ps.pos[0]+ps.size[0])+32, max(ps.pos[1], ps.pos[1]+ps.size[1])+32) {
				ps.mpos = [point_direction(ps.pos[0]+ps.size[0]/2, ps.pos[1]+ps.size[1]/2, _mouse.x, _mouse.y), 0];
				ps.action = 2;
			}
		}
		else {
			switch(ps.action) {
				
				case 1: // move
					ps.pos[0] -= ps.mpos[0] - _mouse.x;
					ps.pos[1] -= ps.mpos[1] - _mouse.y;
					ps.mpos = [_mouse.x, _mouse.y];
					break;
				
				case 2: // rotate
					var a = point_direction(ps.pos[0]+ps.size[0]/2, ps.pos[1]+ps.size[1]/2, _mouse.x, _mouse.y);
					ps.rot -= ps.mpos[0] - a;
					ps.mpos = [a, 0];
					break;
				
				case 3.1: // resize
					ps.pos[0] -= ps.mpos[0] - _mouse.x;
					ps.pos[1] -= ps.mpos[1] - _mouse.y;
					ps.size[0] += ps.mpos[0] - _mouse.x;
					ps.size[1] += ps.mpos[1] - _mouse.y;
					ps.mpos = [_mouse.x, _mouse.y];
					break;
				case 3.2:
					ps.pos[1] -= ps.mpos[1] - _mouse.y;
					ps.size[1] += ps.mpos[1] - _mouse.y;
					ps.mpos = [_mouse.x, _mouse.y];
					break;
				case 3.3:
					ps.pos[1] -= ps.mpos[1] - _mouse.y;
					ps.size[0] -= ps.mpos[0] - _mouse.x;
					ps.size[1] += ps.mpos[1] - _mouse.y;
					ps.mpos = [_mouse.x, _mouse.y];
					break;
				case 3.4:
					ps.size[0] -= ps.mpos[0] - _mouse.x;
					ps.mpos = [_mouse.x, _mouse.y];
					break;
				case 3.5:
					ps.size[0] -= ps.mpos[0] - _mouse.x;
					ps.size[1] -= ps.mpos[1] - _mouse.y;
					ps.mpos = [_mouse.x, _mouse.y];
					break;
				case 3.6:
					ps.size[1] -= ps.mpos[1] - _mouse.y;
					ps.mpos = [_mouse.x, _mouse.y];
					break;
				case 3.7:
					ps.pos[0] -= ps.mpos[0] - _mouse.x;
					ps.size[0] += ps.mpos[0] - _mouse.x;
					ps.size[1] -= ps.mpos[1] - _mouse.y;
					ps.mpos = [_mouse.x, _mouse.y];
					break;
				case 3.8:
					ps.pos[0] -= ps.mpos[0] - _mouse.x;
					ps.size[0] += ps.mpos[0] - _mouse.x;
					ps.mpos = [_mouse.x, _mouse.y];
					break;
			}
		}
	}
	
	draw_surface(_draw_surf, 0, 0);
	
	gpu_set_blendmode(bm_normal);
	
	if keyboard_check_pressed(vk_enter) {
		
		undo_save("draw");
		
		gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
		surface_set_target(_layers[| _current_layer].s);
		draw_surface(_draw_surf, 0, 0);
		surface_reset_target();
		
		clear_surf([_mask_surf, _draw_surf, _alpha_surf, _area_surf]);
		gpu_set_blendmode(bm_normal);
		
		quicksave();
		_pasted_selection.active = false;
		clear_area_select();
		
		return false;
	}
	
	if ps.placed and !mouse_check_button(mb_left) {
		
		surface_set_target(_draw_surf);
		draw_clear_alpha(c_black, 0);
		draw_rectangle(ps.pos[0], ps.pos[1], ps.pos[0]+ps.size[0], ps.pos[1]+ps.size[1], false);
		surface_reset_target();
		
		shader_set(shd_area_outline);
		shader_set_uniform_f_array(shader_get_uniform(shd_area_outline, "texel_size"), [1/_paper_res.w, 1/_paper_res.h]);
		shader_set_uniform_f(shader_get_uniform(shd_area_outline, "time"), get_timer() * 0.000001);
		draw_surface(_draw_surf, 0, 0);
		shader_reset();
		
		var zm = _zoom * 1.5;
		if floor(ps.action) == 3 h[round(frac(ps.action) * 10 - 1)] = 2;
		
		draw_set_color(c_black);
		draw_circle_ext(ps.pos[0], ps.pos[1], (3.5 + h[0]) * zm, 2 * zm, 4);
		draw_circle_ext(ps.pos[0]+ps.size[0]/2, ps.pos[1], (3.5 + h[1]) * zm, 2 * zm, 4);
		draw_circle_ext(ps.pos[0]+ps.size[0], ps.pos[1], (3.5 + h[2]) * zm, 2 * zm, 4);
		draw_circle_ext(ps.pos[0]+ps.size[0], ps.pos[1]+ps.size[1]/2, (3.5 + h[3]) * zm, 2 * zm, 4);
		draw_circle_ext(ps.pos[0]+ps.size[0], ps.pos[1]+ps.size[1], (3.5 + h[4]) * zm, 2 * zm, 4);
		draw_circle_ext(ps.pos[0]+ps.size[0]/2, ps.pos[1]+ps.size[1], (3.5 + h[5]) * zm, 2 * zm, 4);
		draw_circle_ext(ps.pos[0], ps.pos[1]+ps.size[1], (3.5 + h[6]) * zm, 2 * zm, 4);
		draw_circle_ext(ps.pos[0], ps.pos[1]+ps.size[1]/2, (3.5 + h[7]) * zm, 2 * zm, 4);
		draw_set_color(c_white);
		draw_circle_ext(ps.pos[0], ps.pos[1], (2.5 + h[0]) * zm, zm, 4);
		draw_circle_ext(ps.pos[0]+ps.size[0]/2, ps.pos[1], (2.5 + h[1]) * zm, zm, 4);
		draw_circle_ext(ps.pos[0]+ps.size[0], ps.pos[1], (2.5 + h[2]) * zm, zm, 4);
		draw_circle_ext(ps.pos[0]+ps.size[0], ps.pos[1]+ps.size[1]/2, (2.5 + h[3]) * zm, zm, 4);
		draw_circle_ext(ps.pos[0]+ps.size[0], ps.pos[1]+ps.size[1], (2.5 + h[4]) * zm, zm, 4);
		draw_circle_ext(ps.pos[0]+ps.size[0]/2, ps.pos[1]+ps.size[1], (2.5 + h[5]) * zm, zm, 4);
		draw_circle_ext(ps.pos[0], ps.pos[1]+ps.size[1], (2.5 + h[6]) * zm, zm, 4);
		draw_circle_ext(ps.pos[0], ps.pos[1]+ps.size[1]/2, (2.5 + h[7]) * zm, zm, 4);
	}
}
