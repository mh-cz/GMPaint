function save_all_layers() {
	
	var buf = buffer_create(_paper_res.w * _paper_res.h * 4, buffer_grow, 1);
	
	if !directory_exists(_filename) directory_create(_filename);
	
	for(var i = 0; i < ds_list_size(_layers); i++) {
		var layer_data = _layers[| i];
		layer_data.s = check_surf(layer_data.s, _paper_res.w, _paper_res.h, layer_data.c, layer_data.a);
		
		buffer_seek(buf, buffer_seek_start, 0);
		buffer_get_surface(buf, layer_data.s, 0);
		buffer_save(buf, _filename+"/"+string(i)+".l");
	}
	
	buffer_delete(buf);
	
	save_area_select();
}

function save_layer(i = _current_layer) {
	
	var buf = buffer_create(_paper_res.w * _paper_res.h * 4, buffer_grow, 1);
	
	if !directory_exists(_filename) directory_create(_filename);

	var layer_data = _layers[| i];
	layer_data.s = check_surf(layer_data.s, _paper_res.w, _paper_res.h, layer_data.c, layer_data.a);
	
	buffer_seek(buf, buffer_seek_start, 0);
	buffer_get_surface(buf, layer_data.s, 0);
	buffer_save(buf, _filename+"/"+string(i)+".l");
	
	buffer_delete(buf);
	
	save_area_select();
}

function load_all_layers() {
	
	if directory_exists(_filename) {
		
		var files = [];
		var file_name = file_find_first(_filename+"/*.l", fa_readonly);
		
		while(file_name != "") {
		    array_push(files, file_name);
		    file_name = file_find_next();
		}
		file_find_close();
		
		var buf = buffer_create(_paper_res.w * _paper_res.h * 4, buffer_grow, 1);
		
		for(var i = 0; i < ds_list_size(_layers); i++) {
			var layer_data = _layers[| i];
			layer_data.s = check_surf(layer_data.s, _paper_res.w, _paper_res.h, layer_data.c, layer_data.a);
			
			file_name = _filename+"/"+string(i)+".l";
			
			if file_exists(file_name) {
				buf = buffer_load(file_name);
				buffer_set_surface(buf, layer_data.s, 0);
			}
		}
		
		buffer_delete(buf);
	}
	
	load_area_select();
}

function save_area_select() {
	
	var buf = buffer_create(_paper_res.w * _paper_res.h * 4, buffer_grow, 1);
	buffer_seek(buf, buffer_seek_start, 0);
	buffer_get_surface(buf, _area_surf, 0);
	buffer_save(buf, _filename+"/a.s");
	buffer_delete(buf);
}

function load_area_select() {
	
	if file_exists(_filename+"/a.s") {
		var buf = buffer_create(_paper_res.w * _paper_res.h * 4, buffer_grow, 1);
		buf = buffer_load(_filename+"/a.s");
		buffer_set_surface(buf, _area_surf, 0);
		buffer_delete(buf);
	}
}
