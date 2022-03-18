function tool_eraser() {
	
	gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
	
	surface_set_target(_brush.brush_surf);
	draw_clear_alpha(c_black, 0);
	shader_set(shd_brush);
	shader_set_uniform_f(shader_get_uniform(shd_brush, "fo"), _brush.falloff);
	draw_surface(_brush.size_surf, 0, 0);
	shader_reset();
	surface_reset_target();
	
	if !_mouse_over_gui {
		
		if mouse_check_button_pressed(mb_left) undo_save("draw");
		
		if mouse_check_button_pressed(mb_left) and !_brush.moved {
			
			gpu_set_blendmode(bm_subtract);
			surface_set_target(_layers[| _current_layer].s);
			draw_surface_ext(_brush.brush_surf, _brush.pwmx - _brush.size/2, _brush.pwmy - _brush.size/2, 1, 1, 0, 
				make_color_hsv(0, 0, _brush.col[3] * 255), _brush.col[3]);
			surface_reset_target();
		}
		else if mouse_check_button(mb_left) and _brush.moved {
			
			gpu_set_blendmode(bm_subtract);
			surface_set_target(_layers[| _current_layer].s);
			for(var i = 0; i < _brush.pds_wm; i += _brush.step) {
				draw_surface_ext(_brush.brush_surf,
					_brush.pwmx - _brush.size/2 + lengthdir_x(i, _brush.pdr_wm),
					_brush.pwmy - _brush.size/2 + lengthdir_y(i, _brush.pdr_wm), 1, 1, 0, 
					make_color_hsv(0, 0, _brush.col[3] * 255), _brush.col[3]);
			}
			surface_reset_target();
		}
	}
	
	gpu_set_blendmode(bm_normal);
	
	if mouse_check_button_released(mb_left) {
		quicksave();
	}
	
	
}
