gpu_set_texfilter(false);

draw_set_color(c_dkgray);
draw_rectangle(0, 0, _paper_res.w - 1, _paper_res.h - 1, true);

if _current_layer > -1 {

	gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
	for(var i = 0; i < ds_list_size(_layers); i++) {
		if i > _current_layer break;
	
		var layer_data = _layers[| i];
	
		if layer_data.hidden continue;
	
		layer_data.s = check_surf(layer_data.s, _paper_res.w, _paper_res.h, layer_data.c, layer_data.a);
		draw_surface_ext(layer_data.s, 0, 0, 1, 1, 0, make_color_hsv(0, 0, layer_data.layer_alpha*255), layer_data.layer_alpha);
	}
	gpu_set_blendmode(bm_normal);
	
	switch(_current_tool) {
	
		case _tool.brush:
			tool_brush();
			//options_brush();
			break;
		
		case _tool.line:
			tool_line();
			//options_line();
			break;
		
		case _tool.fill:
			tool_fill();
			//options_fill();
			break;
	
		case _tool.eraser:
			tool_eraser();
			//options_eraser();
			break;

		case _tool.pipette:
			tool_pipette();
			//options_pipette();
			break;
	}
	
	gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
	for(var i = _current_layer+1; i < ds_list_size(_layers); i++) {
	
		var layer_data = _layers[| i];
	
		if layer_data.hidden continue;
	
		draw_surface_ext(layer_data.s, 0, 0, 1, 1, 0, make_color_hsv(0, 0, layer_data.layer_alpha*255), layer_data.layer_alpha);
	}
	gpu_set_blendmode(bm_normal);
}