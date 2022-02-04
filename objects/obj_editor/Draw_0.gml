gpu_set_texfilter(false);

draw_set_color(c_dkgray);
draw_rectangle(0, 0, _resolution.w - 1, _resolution.h - 1, true);

gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
for(var i = 0; i < ds_list_size(_layers); i++) {
	var layer_data = _layers[| i];
	layer_data.s = check_surf(layer_data.s, _resolution.w, _resolution.h, layer_data.c, layer_data.a);
	draw_surface_stretched(layer_data.s, 0, 0, _resolution.w, _resolution.h);
}
gpu_set_blendmode(bm_normal);

switch(_tool_current) {
	
	case _tools.brush:
		tool_brush();
		//options_brush();
		break;
		
	case _tools.line:
		tool_line();
		//options_line();
		break;
		
	case _tools.fill:
		tool_fill();
		//options_fill();
		break;
	
	case _tools.eraser:
		tool_eraser();
		//options_fill();
		break;
}
