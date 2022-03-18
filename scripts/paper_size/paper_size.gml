function paper_resolution() {
	
	var xx = screen.w-115;
	var yy = 32;
	
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	
	if point_in_rectangle(mx, my, xx-2, yy-10, xx+120, yy+26) _mouse_over_gui = true;
	
	input_draw("paper w", xx, yy, mx, my);
	input_draw("paper h", xx+60, yy, mx, my);
	draw_text_outlined(xx+48, yy+4, "X");
	
	var resize = function() {
		
		var copy_n_cut = function(surf, temp_surf) {
			
			surface_set_target(temp_surf);
			draw_clear_alpha(c_black, 0);
			draw_surface(l.s, 0, 0);
			surface_reset_target();
			
			surface_resize(l.s, _paper_res.w, _paper_res.h);

			var pw = surface_get_width(temp_surf);
			var ph = surface_get_height(temp_surf);
			
			surface_set_target(l.s);
			draw_clear_alpha(c_black, 0);
			draw_surface(temp_surf, 0, 0);
			draw_set_alpha(0);
			draw_set_color(c_black);
			draw_rectangle(_paper_res.w-pw, _paper_res.w, _paper_res.h-ph, _paper_res.h, false);
			draw_set_alpha(1);
			surface_reset_target();
		}
		
		var temp_surf = surface_create(_paper_res.w, _paper_res.h);
		clear_surf(temp_surf);
		gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
		foreach "l" in _layers copy_n_cut(l.s, temp_surf);
		gpu_set_blendmode(bm_normal);
		surface_free(temp_surf);
		
		surface_resize(_mask_surf, _paper_res.w, _paper_res.h);		
		surface_resize(_draw_surf, _paper_res.w, _paper_res.h);		
		surface_resize(_alpha_surf, _paper_res.w, _paper_res.h);		
		surface_resize(_img_ovr_surf, _paper_res.w, _paper_res.h);		
		surface_resize(_area_surf, _paper_res.w, _paper_res.h);	
		clear_area_select();
	}
	
	if keyboard_check_pressed(vk_enter) and _selected_input != "" {
		var t = input_get_text(_selected_input);
		if t != "" and t == string_digits(t) {
			switch(_selected_input) {
				case "paper w":
					_paper_res.w = clamp(floor(real(t)), 1, 4096);
					input_set_text(_selected_input, _paper_res.w);
					resize();
					break;
				case "paper h":
					_paper_res.h = clamp(floor(real(t)), 1, 4096);
					input_set_text(_selected_input, _paper_res.h);
					resize();
					break;
			}
		}
	}
}
