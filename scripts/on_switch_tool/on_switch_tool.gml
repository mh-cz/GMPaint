function on_switch_tool(nt) {
	
	if nt == _current_tool return 0;
	
	// OLD TOOL
	switch(_current_tool) {
	
		case _tool.brush:
			break;
		
		case _tool.line:
			break;
		
		case _tool.fill:
			_fill.phase = 0;
			_fill.n = 0;
			clear_surf([_mask_surf, _draw_surf, _alpha_surf]);
			free_surf([_fill.surf, _fill.copy_surf, _fill.comp_surf, _fill.find_col_surf, _fill.one_px_surf]);
			break;
	
		case _tool.eraser:
			break;

		case _tool.pipette:

			break;
	}
	
	// NEW TOOL
	switch(nt) {
	
		case _tool.brush:
			break;
		
		case _tool.line:
			break;
		
		case _tool.fill:
			break;
	
		case _tool.eraser:
			break;
		
		case _tool.pipette:
			
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			surface_set_target(_draw_surf);
			draw_clear_alpha(c_black, 0);
			
			var num = ds_list_size(_layers)-1;
			for(var l = num; l > -1; l--) {
				var lr = _layers[| l];
				if !lr.hidden draw_surface_ext(lr.s, 0, 0, 1, 1, 0, make_color_hsv(0, 0, lr.layer_alpha*255), lr.layer_alpha);
			}
			
			surface_reset_target();
			gpu_set_blendmode(bm_normal);
			break;
			
	}
}
