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
			for(var i = 0; i < ds_list_size(_layers); i++) {
				buffer_delete(_pipette.buf_list[| i]);
			}
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
			for(var i = 0; i < ds_list_size(_layers); i++) {
				_pipette.buf_list[| i] = buffer_create(_paper_res.w * _paper_res.h * 4, buffer_fixed, 1);
				buffer_get_surface(_pipette.buf_list[| i], _layers[| i].s, 0);
			}
			break;
	}
}
