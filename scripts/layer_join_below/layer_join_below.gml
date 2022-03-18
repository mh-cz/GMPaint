function layer_join_below(l) {
	
	if l == 0 return 0;
	
	var l_above = _layers[| l];
	var l_below = _layers[| l-1];
	
	if l_below.hidden {
		layer_delete(l-1);
		return 0;
	}
	
	if !l_above.hidden {
		gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
		surface_set_target(l_below.s);
		draw_surface_ext(l_above.s, 0, 0, 1, 1, 0, make_color_hsv(0, 0, l_above.layer_alpha*255), l_above.layer_alpha);
		surface_reset_target();
		gpu_set_blendmode(bm_normal);
	}
	
	layer_delete(l);
}

function layer_join_all() {
	
	var num = ds_list_size(_layers)-1;
	
	for(var l = num; l > 0; l--) {
		
		var l_above = _layers[| l];
		var l_below = _layers[| l-1];
		
		if l_below.hidden {
			layer_delete(l-1);
			continue;
		}
		
		if !l_above.hidden {
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			surface_set_target(l_below.s);
			draw_surface_ext(l_above.s, 0, 0, 1, 1, 0, make_color_hsv(0, 0, l_above.layer_alpha*255), l_above.layer_alpha);
			surface_reset_target();
			gpu_set_blendmode(bm_normal);
		}
	
		layer_delete(l);
	}
}

function move_layer_up() {
	if _current_layer < ds_list_size(_layers)-1 {
		var this = _layers[| _current_layer+1];
		_layers[| _current_layer+1] = _layers[| _current_layer];
		_layers[| _current_layer] = this;
		_current_layer++;
	}
}

function move_layer_down() {
	if _current_layer > 0 {
		var this = _layers[| _current_layer-1];
		_layers[| _current_layer-1] = _layers[| _current_layer];
		_layers[| _current_layer] = this;
		_current_layer--;
	}
}
