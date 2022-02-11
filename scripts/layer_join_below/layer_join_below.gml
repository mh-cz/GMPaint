function layer_join_below(l) {
	
	if l == 0 return 0;
	
	var l_above = _layers[| l];
	var l_below = _layers[| l-1];
	
	gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
	surface_set_target(l_below.s);
	draw_surface(l_above.s, 0, 0);
	surface_reset_target();
	gpu_set_blendmode(bm_normal);
	
	layer_delete(l);
}

function layer_join_all() {
	
	var num = ds_list_size(_layers)-1;
	
	for(var l = num; true; l--) {
		
		if l == 0 return 0;
	
		var l_above = _layers[| l];
		var l_below = _layers[| l-1];
	
		gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
		surface_set_target(l_below.s);
		draw_surface(l_above.s, 0, 0);
		surface_reset_target();
		gpu_set_blendmode(bm_normal);
	
		layer_delete(l);
	}
}