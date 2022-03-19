function paper_resolution() {
	
	var xx = screen.w-115;
	var yy = 32;
	
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	
	if point_in_rectangle(mx, my, xx-2, yy-10, xx+120, yy+26) _mouse_over_gui = true;
	
	if !_paper_res_drag.options_init {
		_paper_res_drag.options_init = true;
		_paper_res_drag.size[0] = _paper_res.w;
		_paper_res_drag.size[1] = _paper_res.h;
		input_set_text("paper w", _paper_res_drag.size[0]);
		input_set_text("paper h", _paper_res_drag.size[1]);
	}
	
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
					_paper_res_drag.size[0] = _paper_res.w;
					resize();
					break;
				case "paper h":
					_paper_res.h = clamp(floor(real(t)), 1, 4096);
					input_set_text(_selected_input, _paper_res.h);
					_paper_res_drag.size[1] = _paper_res.h;
					resize();
					break;
			}
		}
	}
}

function paper_resolution_drag() {
	
	var prd = _paper_res_drag;
	var h = [0,0,0];
	
	if mouse_check_button_released(mb_left) and prd.action != 0 {
		
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
		
		_paper_res.w = prd.size[0];
		_paper_res.h = prd.size[1];
		
		var temp_surf = surface_create(_paper_res.w, _paper_res.h);
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
	
	if !mouse_check_button(mb_left) {
		
		prd.action = 0;
		
		var r = max(1, 5 * _zoom * 1.5);
		
		if point_distance(prd.size[0]+16, prd.size[1] div 2, _mouse.x, _mouse.y) < r {
			prd.mpos = [_mouse.x, _mouse.y];
			prd.action = 1;
		}
		else if point_distance(prd.size[0]+16, prd.size[1]+16, _mouse.x, _mouse.y) < r {
			prd.mpos = [_mouse.x, _mouse.y];
			prd.action = 2;
		}
		else if point_distance(prd.size[0] div 2, prd.size[1]+16, _mouse.x, _mouse.y) < r {
			prd.mpos = [_mouse.x, _mouse.y];
			prd.action = 3;
		}
	}
	else {
		switch(prd.action) {
			case 1:
				prd.size[0] -= prd.mpos[0] - _mouse.x;
				break;
			case 2:
				prd.size[0] -= prd.mpos[0] - _mouse.x;
				prd.size[1] -= prd.mpos[1] - _mouse.y;
				break;
			case 3:
				prd.size[1] -= prd.mpos[1] - _mouse.y;
				break;
		}
		
		prd.size[0] = clamp(prd.size[0], 1, 4096);
		prd.size[1] = clamp(prd.size[1], 1, 4096);
		prd.mpos = [_mouse.x, _mouse.y];
		
		input_set_text("paper w", prd.size[0]);
		input_set_text("paper h", prd.size[1]);
		
		if prd.action != 0 {
			draw_set_color(c_white);
			draw_rectangle(0, 0, prd.size[0]-1, prd.size[1]-1, true);
			draw_set_color(c_black);
			draw_rectangle(-1.5*_zoom, -1.5*_zoom, prd.size[0]-1+1.5*_zoom, prd.size[1]-1+1.5*_zoom, true);
		}
	}
	
	var zm = _zoom * 1.5;
	if prd.action > 0 h[prd.action - 1] = 2;
	
	if prd.action == 0 or !mouse_check_button(mb_left) {
		draw_set_alpha(0.35);
		draw_set_color(c_black);
		draw_circle_ext(prd.size[0]+16, prd.size[1] div 2, (3.5 + h[0]) * zm, 2 * zm, 4);
		draw_circle_ext(prd.size[0]+16, prd.size[1]+16, (3.5 + h[1]) * zm, 2 * zm, 4);
		draw_circle_ext(prd.size[0] div 2, prd.size[1]+16, (3.5 + h[2]) * zm, 2 * zm, 4);
		draw_set_color(c_white);
		draw_circle_ext(prd.size[0]+16, prd.size[1] div 2, (2.5 + h[0]) * zm, zm, 4);
		draw_circle_ext(prd.size[0]+16, prd.size[1]+16, (2.5 + h[1]) * zm, zm, 4);
		draw_circle_ext(prd.size[0] div 2, prd.size[1]+16, (2.5 + h[2]) * zm, zm, 4);
		draw_set_alpha(1);
	}
}
