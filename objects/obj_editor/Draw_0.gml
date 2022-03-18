gpu_set_texfilter(false);

if _current_layer > -1 {

	gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
	
	foreach ["iter","l"] in _layers as_list {
		if iter > _current_layer break;
		if l.hidden continue;
		draw_surface_ext(l.s, 0, 0, 1, 1, 0, make_color_hsv(0, 0, l.layer_alpha*255), l.layer_alpha);
	}
	
	gpu_set_blendmode(bm_normal);
	
	if _pasted_selection.active {
		pasted_selection();
	}
	else switch(_current_tool) {
		case _tool.brush: tool_brush(); break;
		case _tool.line: tool_line(); break;
		case _tool.fill: tool_fill(); break;
		case _tool.eraser: tool_eraser(); break;
		case _tool.pipette: tool_pipette(); break;
		case _tool.area_select: tool_area(); break;
	}
	
	gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
	
	for(var i = _current_layer+1; i < ds_list_size(_layers); i++) {
		var layer_data = _layers[| i];
		if layer_data.hidden continue;
		draw_surface_ext(layer_data.s, 0, 0, 1, 1, 0, make_color_hsv(0, 0, layer_data.layer_alpha*255), layer_data.layer_alpha);
	}
	
	gpu_set_blendmode(bm_normal);
}
