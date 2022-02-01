function save_all_layers() {
	
	var buf = buffer_create(_resolution.w * _resolution.h * 4, buffer_grow, 1);
	
	if !directory_exists(_filename) directory_create(_filename);
	
	for(var i = 0; i < ds_list_size(_layers); i++) {
		var layer_data = _layers[| i];
		layer_data.s = check_surf(layer_data.s, _resolution.w, _resolution.h, layer_data.c, layer_data.a);
		
		buffer_seek(buf, buffer_seek_start, 0);
		buffer_get_surface(buf, layer_data.s, 0);
		buffer_save(buf, _filename + "/layer." + string(i));
	}
	
	buffer_delete(buf);
}

function save_layer(i = _current_layer) {
	
	var buf = buffer_create(_resolution.w * _resolution.h * 4, buffer_grow, 1);
	
	if !directory_exists(_filename) directory_create(_filename);

	var layer_data = _layers[| i];
	layer_data.s = check_surf(layer_data.s, _resolution.w, _resolution.h, layer_data.c, layer_data.a);
		
	buffer_seek(buf, buffer_seek_start, 0);
	buffer_get_surface(buf, layer_data.s, 0);
	buffer_save(buf, _filename + "/layer." + string(i));
	
	buffer_delete(buf);
}
