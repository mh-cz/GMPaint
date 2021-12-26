function tool_fill() {
	
	var surf = _layers[| _current_layer].s;
	var w = surface_get_width(_mask_surf);
	var h = surface_get_height(_mask_surf);
	
	if device_mouse_check_button_pressed(0, mb_left) and _fill.phase == 0 and !_mouse_over_gui {
		if mouse_x > 0 and mouse_y > 0 and mouse_x < _resolution.w and mouse_y < _resolution.h {
			
			surface_set_target(_mask_surf);
			draw_clear_alpha(c_black, 0);
			draw_sprite(spr_1px, 0, mouse_x, mouse_y)
			surface_reset_target();
		
			var sc = c2rgba(surface_getpixel_ext(surf, mouse_x, mouse_y));
			_fill.start_col = [sc[0]/255, sc[1]/255, sc[2]/255, sc[3]/255];
			_fill.start_pos = [mouse_x, mouse_y];
			_fill.phase = 1;
			_fill.n = 1;
		}
	}
	
	if _fill.phase == 1 {
		
		_fill.surf = check_surf(_fill.surf, w, h);
		_fill.comp_surf = check_surf(_fill.comp_surf, w, h);
		_fill.copy_surf = check_surf(_fill.copy_surf, w, h);
		_fill.find_col_surf = check_surf(_fill.find_col_surf, w, h);
		
		shader_set(shd_flood_fill);
		shader_set_uniform_f_array(shader_get_uniform(shd_flood_fill, "start_pos"), _fill.start_pos);
		shader_set_uniform_f_array(shader_get_uniform(shd_flood_fill, "texel_size"), [1/w, 1/h]);
		shader_set_uniform_f(shader_get_uniform(shd_flood_fill, "tolerance"), _fill.tol/255);
		shader_set_uniform_f_array(shader_get_uniform(shd_flood_fill, "start_col"), _fill.start_col);
		texture_set_stage(shader_get_sampler_index(shd_flood_fill, "img"), surface_get_texture(_layers[| _current_layer].s));
		
		if _fill.n > 1 surface_copy(_fill.copy_surf, 0, 0, _mask_surf);
		
		if floor(_fill.n) % 5 != 0 {
			
			repeat(50) {
				surface_set_target(_fill.surf);
				draw_surface(_mask_surf, 0, 0);
				surface_reset_target();
				surface_set_target(_mask_surf);
				draw_surface(_fill.surf, 0, 0);
				surface_reset_target();
			}
		}
		
		shader_reset();
		
		if _fill.n > 1 {
			
			shader_set(shd_compare_surfaces);
			texture_set_stage(shader_get_sampler_index(shd_compare_surfaces, "img1"), surface_get_texture(_fill.copy_surf));
			texture_set_stage(shader_get_sampler_index(shd_compare_surfaces, "img2"), surface_get_texture(_mask_surf));
			surface_set_target(_fill.comp_surf);
			draw_surface(_fill.surf, 0, 0);
			surface_reset_target();
			shader_reset();
			
			if floor(_fill.n) % 5 == 0 {
				
				shader_set(shd_find_color);
				shader_set_uniform_f_array(shader_get_uniform(shd_find_color, "texel_size"), [1/w, 1/h]);
				
				surface_set_target(_fill.find_col_surf);
				draw_clear_alpha(c_black, 0);
				draw_surface_ext(_fill.comp_surf, 0, 0, 1, 1, 0, c_white, 1);
				surface_reset_target();
				shader_reset();
				
				var c = c2rgba(surface_getpixel_ext(_fill.find_col_surf, 0, 0));
				if c[0] == 0 _fill.phase = 2;
			}
		}
		
		_fill.n++;
	}
	else if _fill.phase == 2 {
		
		_fill.phase = 0;
		
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
		free_surf([_fill.surf, _fill.copy_surf, _fill.comp_surf, _fill.find_col_surf]);
		
		gpu_set_blendmode(bm_normal);
	}
	
	#region      /////////////////      DRAW      /////////////////

	for(var i = 0; i < ds_list_size(_layers); i++) {
		var layer_data = _layers[| i];
		layer_data.s = check_surf(layer_data.s, _resolution.w, _resolution.h, layer_data.c, layer_data.a);
	
		gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
		draw_surface(layer_data.s, 0, 0);
		gpu_set_blendmode(bm_normal);
	}

	draw_set_color(c_dkgray);
	draw_rectangle(0, 0, _resolution.w - 1, _resolution.h - 1, true);

	draw_surface(_alpha_surf, 0, 0);
	
	if _fill.phase != 0 {
		
		draw_surface_ext(_mask_surf, 0, 0, 1, 1, 0, rgba2c(_brush.col, 255), _brush.col[3]);
	}
	
	draw_set_color(c_dkgray);
	draw_circle(_brush.wmx-1, _brush.wmy-1, _brush.size/2 - 1, true);
	draw_set_color(c_white);
	
	#endregion
}
