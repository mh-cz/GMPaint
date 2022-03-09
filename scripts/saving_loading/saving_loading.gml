function save() {
	if _filename == "" {
		var new_path = get_save_filename_ext("*"+_file_ext, _langstr[$ _language].new_file, "", _langstr[$ _language].save_save_location);
		if new_path == "" return 0;
		_fpath = new_path;
		
		var len = string_length(_fpath);
		for(var i = len; i > 0; i--) {
			if string_char_at(_fpath, i) == "\\" {
				var new_filename = string_copy(_fpath, i+1, len-i);
				if string_replace_all(new_filename, " ", "") == "" return 0;
				_filename = new_filename;
				break;
			}
		}
	}
	
	if !directory_exists(_fpath) directory_create(_fpath);
	
	save_all_layers();
	
	set_bottom_right_text("Saved: "+_fpath, 2);
}

function save_all_layers() {
	
	var buf = buffer_create(_paper_res.w * _paper_res.h * 4, buffer_fixed, 1);
	
	for(var i = 0; i < ds_list_size(_layers); i++) {
		var layer_data = _layers[| i];
		layer_data.s = check_surf(layer_data.s, _paper_res.w, _paper_res.h, layer_data.c, layer_data.a);
		
		buffer_seek(buf, buffer_seek_start, 0);
		buffer_get_surface(buf, layer_data.s, 0);
		buffer_save(buf, _fpath+"/"+string(i)+".l");
	}
	
	buffer_delete(buf);
	
	save_area_select();
}

function save_layer(i = _current_layer) {
	
	var buf = buffer_create(_paper_res.w * _paper_res.h * 4, buffer_fixed, 1);
	
	var layer_data = _layers[| i];
	layer_data.s = check_surf(layer_data.s, _paper_res.w, _paper_res.h, layer_data.c, layer_data.a);
	
	buffer_seek(buf, buffer_seek_start, 0);
	buffer_get_surface(buf, layer_data.s, 0);
	buffer_save(buf, _fpath+"/"+string(i)+".l");
	
	buffer_delete(buf);
	
	save_area_select();
}

function load_all_layers() {
	
	if directory_exists(_fpath) {
		
		var files = [];
		var file_name = file_find_first(_fpath+"/*.l", fa_readonly);
		
		while(file_name != "") {
		    array_push(files, file_name);
		    file_name = file_find_next();
		}
		file_find_close();
		
		var buf = buffer_create(_paper_res.w * _paper_res.h * 4, buffer_fixed, 1);
		
		for(var i = 0; i < ds_list_size(_layers); i++) {
			var layer_data = _layers[| i];
			layer_data.s = check_surf(layer_data.s, _paper_res.w, _paper_res.h, layer_data.c, layer_data.a);
			
			file_name = _fpath+"/"+string(i)+".l";
			
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
	
	var buf = buffer_create(_paper_res.w * _paper_res.h * 4, buffer_fixed, 1);
	buffer_seek(buf, buffer_seek_start, 0);
	buffer_get_surface(buf, _area_surf, 0);
	buffer_save(buf, _filename+"/a.s");
	buffer_delete(buf);
}

function load_area_select() {
	
	if file_exists(_filename+"/a.s") {
		var buf = buffer_create(_paper_res.w * _paper_res.h * 4, buffer_fixed, 1);
		buf = buffer_load(_filename+"/a.s");
		buffer_set_surface(buf, _area_surf, 0);
		buffer_delete(buf);
	}
}
