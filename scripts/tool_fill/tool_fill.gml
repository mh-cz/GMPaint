function tool_fill() {
	
	var surf = _layers[| _current_layer].s;
	var w = surface_get_width(_mask_surf);
	var h = surface_get_height(_mask_surf);
	
	if device_mouse_check_button_pressed(0, mb_left) and _fill.phase == 0 and !_mouse_over_gui {
		if _mouse.x > 0 and _mouse.y > 0 and _mouse.x < _resolution.w and _mouse.y < _resolution.h {
			
			surface_set_target(_mask_surf);
			draw_clear_alpha(c_black, 0);
			draw_sprite(spr_1px, 0, _mouse.x, _mouse.y)
			surface_reset_target();
			
			var sc = c2rgba(surface_getpixel_ext(surf, _mouse.x, _mouse.y));
			_fill.start_col = [sc[0]/255, sc[1]/255, sc[2]/255, sc[3]/255];
			_fill.start_pos = [_mouse.x, _mouse.y];
			_fill.phase = 1;
			_fill.n = 1;
		}
	}
	
	if _fill.phase == 1 {
		
		_fill.surf = check_surf(_fill.surf, w, h);
		_fill.comp_surf = check_surf(_fill.comp_surf, w, h);
		_fill.copy_surf = check_surf(_fill.copy_surf, w, h);
		_fill.find_col_surf = check_surf(_fill.find_col_surf, w, h);
		_fill.one_px_surf = check_surf(_fill.one_px_surf, 1, 1);
		
		shader_set(shd_flood_fill);
		shader_set_uniform_f_array(shader_get_uniform(shd_flood_fill, "start_pos"), _fill.start_pos);
		shader_set_uniform_f_array(shader_get_uniform(shd_flood_fill, "texel_size"), [1/w, 1/h]);
		shader_set_uniform_f(shader_get_uniform(shd_flood_fill, "tolerance"), _fill.tol/255);
		shader_set_uniform_f_array(shader_get_uniform(shd_flood_fill, "start_col"), _fill.start_col);
		texture_set_stage(shader_get_sampler_index(shd_flood_fill, "img"), surface_get_texture(_layers[| _current_layer].s));
		
		if _fill.n > 1 surface_copy(_fill.copy_surf, 0, 0, _mask_surf);
			
		repeat(20) {
			surface_set_target(_fill.surf);
			draw_surface(_mask_surf, 0, 0);
			surface_reset_target();
			surface_set_target(_mask_surf);
			draw_surface(_fill.surf, 0, 0);
			surface_reset_target();
		}
		
		shader_reset();
		
		if _fill.n > 0 {
			
			if floor(_fill.n) % 2 == 1 {
			
				shader_set(shd_compare_surfaces);
				texture_set_stage(shader_get_sampler_index(shd_compare_surfaces, "img1"), surface_get_texture(_fill.copy_surf));
				texture_set_stage(shader_get_sampler_index(shd_compare_surfaces, "img2"), surface_get_texture(_mask_surf));
				surface_set_target(_fill.comp_surf);
				draw_surface(_fill.surf, 0, 0);
				surface_reset_target();
				shader_reset();
				
				shader_set(shd_find_color);
				shader_set_uniform_f_array(shader_get_uniform(shd_find_color, "texel_size"), [1/w, 1/h]);
				surface_set_target(_fill.find_col_surf);
				draw_clear_alpha(c_black, 0);
				draw_surface(_fill.comp_surf, 0, 0);
				surface_reset_target();
				shader_reset();
				
				surface_set_target(_fill.one_px_surf);
				draw_clear_alpha(c_black, 0);
				draw_surface(_fill.find_col_surf, 0, 0);
				surface_reset_target();
				
				var buf = buffer_create(1, buffer_grow, 1);
				buffer_get_surface(buf, _fill.one_px_surf, 0);
				if buffer_peek(buf, 0, buffer_fast) == 0 _fill.phase = 2;
				buffer_delete(buf);
			}
		}
		
		_fill.n++;
	}
	else if _fill.phase == 2 {
		
		_fill.phase = 0;
		_fill.n = 0;
		
		surface_set_target(_draw_surf);
		draw_clear_alpha(c_black, 0);
		draw_surface(_mask_surf, 0, 0);
		gpu_set_colorwriteenable(true, true, true, false);
		draw_sprite_stretched_ext(spr_1px, 0, 0, 0, _resolution.w, _resolution.h, rgba2c(_brush.col, 255), 1);
		gpu_set_colorwriteenable(true, true, true, true);
		gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
		surface_reset_target();
		
		surface_set_target(_alpha_surf);
		draw_clear_alpha(c_black, 0);
		draw_surface_ext(_draw_surf, 0, 0, 1, 1, 0, c_white, clamp(_brush.col[3] * 1.5, 0, 1));
		surface_reset_target();
		
		surface_set_target(_layers[| _current_layer].s);
		shader_set(shd_premultiply_alpha);
		draw_surface(_alpha_surf, 0, 0);
		shader_reset();
		surface_reset_target();
		
		clear_surf([_mask_surf, _draw_surf, _alpha_surf]);
		free_surf([_fill.surf, _fill.copy_surf, _fill.comp_surf, _fill.find_col_surf, _fill.one_px_surf]);
		save_layer(_current_layer);
		
		gpu_set_blendmode(bm_normal);
		
		save_layer();
	}
}
