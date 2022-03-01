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
	
	gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
	
	if !_pasted_selection.placed {
		
		_pasted_selection.pos = [_mouse.x - round(_pasted_selection.size[0]/2), _mouse.y - round(_pasted_selection.size[1]/2)];
		draw_surface(_copy_surf, _pasted_selection.pos[0], _pasted_selection.pos[1]);		
		
		if mouse_check_button_pressed(mb_left) and !_mouse_over_gui _pasted_selection.placed = true;
	}
	else {
		draw_surface_general(_copy_surf, 0, 0, _pasted_selection.size[0], _pasted_selection.size[1], 
			_pasted_selection.pos[0], _pasted_selection.pos[1],
			_area_select.copy_surf_size[0]/_pasted_selection.size[0], _area_select.copy_surf_size[1]/_pasted_selection.size[1], 
			_pasted_selection.rot, c_white, c_white, c_white, c_white, 1);
		
	}
	
	gpu_set_blendmode(bm_normal);
	
}
