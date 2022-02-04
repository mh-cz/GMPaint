function tool_brush() {
	
	gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
	
	surface_set_target(_brush.brush_surf);
	draw_clear_alpha(c_black, 0);
	shader_set(shd_brush);
	shader_set_uniform_f(shader_get_uniform(shd_brush, "fo"), _brush.falloff);
	draw_surface(_brush.size_surf, 0, 0);
	shader_reset();
	surface_reset_target();
	
	if mouse_check_button_pressed(mb_left) {
		_brush.moved = true;
		_brush.pds_wm = _brush.step;
	}
	
	if mouse_check_button(mb_left) and _brush.moved and !_mouse_over_gui {
		
		surface_set_target(_mask_surf);
		for(var i = 0; i < _brush.pds_wm; i += _brush.step) {
			draw_surface(_brush.brush_surf,
				_brush.pwmx - _brush.size/2 + lengthdir_x(i, _brush.pdr_wm),
				_brush.pwmy - _brush.size/2 + lengthdir_y(i, _brush.pdr_wm));
		}
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
	}
	
	gpu_set_blendmode(bm_normal);
	
	// EXTRA DRAW
	draw_surface(_alpha_surf, 0, 0);
	
	// APPLY
	if mouse_check_button_released(mb_left) {
		
		gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
		surface_set_target(_layers[| _current_layer].s);
		shader_set(shd_premultiply_alpha);
		draw_surface(_alpha_surf, 0, 0);
		shader_reset();
		surface_reset_target();
		
		clear_surf([_mask_surf, _draw_surf, _alpha_surf]);
		gpu_set_blendmode(bm_normal);
		
		save_layer();
	}
}
