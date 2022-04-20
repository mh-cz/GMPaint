function undo_save(action = "") {
	
	switch(action) {
		case "draw":
			ds_list_add(_undo_list, buffer_create(0, buffer_grow, 1));
			_undo_counter = ds_list_size(_undo_list)-1;
			var undo_buf = _undo_list[| _undo_counter];
			
			//foreach ["b", 1, _undo_counter+1] in _undo_list as_list buffer_delete(b);
			
			var bact = buffer_create(128, buffer_fixed, 1); // buffer action
			var bl = buffer_create(_paper_res.w * _paper_res.h * 4, buffer_fixed, 1); // buffer layer
			var size = buffer_get_size(bl);
			
			buffer_get_surface(bl, _layers[| _current_layer].s, 128);
			buffer_copy(bl, 0, size, undo_buf, buffer_get_size(undo_buf));
			buffer_write(bact, buffer_string, json_stringify({ A: action, L: _current_layer }));
			buffer_copy(bact, 0, 128, undo_buf, 0);
			
			buffer_delete(bact);
			buffer_delete(bl);
			break;
	}
}

function undo() {
	
	if _undo_counter-1 < 0 return false;
	
	var load_buf = _undo_list[| _undo_counter--];
	var bact = buffer_create(128, buffer_fixed, 1);
	
	buffer_copy(load_buf, 0, 128, bact, 0);
	var action = json_parse(buffer_read(bact, buffer_string));
	
	if !is_struct(action) { show_debug_message(string(action)); return false };
	
	switch(action.A) {
		case "draw":
			
			var bl = buffer_create(_paper_res.w * _paper_res.h * 4, buffer_fixed, 1);
			buffer_copy(load_buf, 128, _paper_res.w * _paper_res.h * 4, bl, 0);
			buffer_set_surface(bl, _layers[| action.L].s, 0);
			buffer_delete(bl);
			
			break;
	}
	
	buffer_delete(bact);
	
	quicksave("quick");
}

