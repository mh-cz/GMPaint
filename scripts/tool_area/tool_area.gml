function tool_area() {
	
	if _area_select.mode == 2 {
		
		gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
	
		surface_set_target(_brush.brush_surf);
		draw_clear_alpha(c_black, 0);
		shader_set(shd_brush);
		shader_set_uniform_f(shader_get_uniform(shd_brush, "fo"), 99999);
		draw_surface(_brush.size_surf, 0, 0);
		shader_reset();
		surface_reset_target();
	
		if mouse_check_button_pressed(mb_left) {
			_brush.moved = true;
			_brush.pds_wm = _brush.step;
		}
	}
	
	if mouse_check_button_pressed(mb_left) and !_mouse_over_gui {
		_area_select.start_pos = [_mouse.x, _mouse.y];
		if !keyboard_check(vk_control) and !keyboard_check(vk_shift) clear_surf(_area_surf);
	}
	
	if mouse_check_button(mb_left) and !_mouse_over_gui {
		
		if _area_select.mode == 0 {
			
			surface_set_target(_alpha_surf);
			draw_clear_alpha(c_black, 0);
			draw_set_color(keyboard_check(vk_shift) ? c_red : c_blue);
			draw_set_alpha(1);
			draw_rectangle(_area_select.start_pos[0], _area_select.start_pos[1], _mouse.x, _mouse.y, false);
			surface_reset_target();
		}
		else if _area_select.mode == 1 {
			
			surface_set_target(_alpha_surf);
			draw_clear_alpha(c_black, 0);
			draw_set_color(keyboard_check(vk_shift) ? c_red : c_blue);
			draw_set_alpha(1);
			draw_ellipse(_area_select.start_pos[0], _area_select.start_pos[1], _mouse.x, _mouse.y, false);
			surface_reset_target();
		}
		else if _area_select.mode == 2 {
		
			if keyboard_check(vk_shift) {
				gpu_set_blendmode(bm_subtract);
				surface_set_target(_area_surf);
				for(var i = 0; i < _brush.pds_wm; i += _brush.step) {
					draw_surface_ext(_brush.brush_surf,
						_brush.pwmx - _brush.size/2 + lengthdir_x(i, _brush.pdr_wm),
						_brush.pwmy - _brush.size/2 + lengthdir_y(i, _brush.pdr_wm), 1, 1, 0, 
						make_color_hsv(0, 0, _brush.col[3] * 255), _brush.col[3]);
				}
				surface_reset_target();
			}
			else {
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
				draw_sprite_stretched_ext(spr_1px, 0, 0, 0, _paper_res.w, _paper_res.h, c_blue, 1);
				gpu_set_colorwriteenable(true, true, true, true);
				gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
				surface_reset_target();
		
				surface_set_target(_alpha_surf);
				draw_clear_alpha(c_black, 0);
				draw_surface_ext(_draw_surf, 0, 0, 1, 1, 0, c_white, 1);
				surface_reset_target();
			}
		}
	}
	gpu_set_blendmode(bm_normal);
	
	// EXTRA DRAW
	if mouse_check_button(mb_left) {
			
			draw_surface_ext(_alpha_surf, 0, 0, 1, 1, 0, c_white, 0.25);
			
			shader_set(shd_area_outline);
			shader_set_uniform_f_array(shader_get_uniform(shd_area_outline, "texel_size"), [1/_paper_res.w, 1/_paper_res.h]);
			shader_set_uniform_f(shader_get_uniform(shd_area_outline, "time"), get_timer() * 0.000001);
			draw_surface(_alpha_surf, 0, 0);
			shader_reset();
	}
	
	// APPLY
	if mouse_check_button_released(mb_left) {
		
		if keyboard_check(vk_shift) gpu_set_blendmode(bm_subtract);
		else gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
		
		surface_set_target(_area_surf);
		shader_set(shd_premultiply_alpha);
		draw_surface(_alpha_surf, 0, 0);
		shader_reset();
		surface_reset_target();
		
		clear_surf([_mask_surf, _draw_surf, _alpha_surf]);
		gpu_set_blendmode(bm_normal);
		
		//save_layer();
		
	}
}

function clear_area_select() {
	surface_set_target(_area_surf);
	draw_clear(c_blue);
	surface_reset_target();
}
