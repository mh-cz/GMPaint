function save() {
	
	if _filename == "" {
		var new_path = get_save_filename_ext(_file_ext, _langstr[$ _language].new_file, _last_fpath, _langstr[$ _language].save_caption);
		if new_path == "" return false;
		_fpath = new_path;
		
		var plen = string_length(_fpath)
		var elen = string_length(_file_ext);
		
		if string_copy(_fpath, plen-elen+1, elen) == _file_ext {
			for(var i = plen; i > 0; i--) {
				if string_char_at(_fpath, i) == "\\" {
					_fpath = string_copy(_fpath, 1, i-1);
					directory_destroy(_fpath);
					break;
				}
			}
		}
		
		for(var i = plen; i > 0; i--) {
			if string_char_at(_fpath, i) == "\\" {
				var new_filename = string_copy(_fpath, i+1, plen-i);
				if string_replace_all(new_filename, " ", "") == "" return false;
				_filename = new_filename;
				break;
			}
		}
	}
	
	_last_fpath = _fpath;
	
	if !directory_exists(_fpath) directory_create(_fpath);
	
	save_all_layers();
	save_settings();
	
	set_bottom_right_text("Saved: "+_fpath, 2);
	
	return true;
}

function save_as() {
	
	var old = [_fpath, _filename];
	_filename = "";
	_fpath = "";
	
	if save() set_bottom_right_text("Saved as: "+_fpath, 2);
	
	_fpath = old[0];
	_filename = old[1];
}

function save_all_layers() {
	
	var buf = buffer_create(_paper_res.w * _paper_res.h * 4, buffer_fixed, 1);
	
	for(var i = 0; i < ds_list_size(_layers); i++) {
		var layer_data = _layers[| i];
		layer_data.s = check_surf(layer_data.s, _paper_res.w, _paper_res.h, layer_data.c, layer_data.a);
		
		buffer_seek(buf, buffer_seek_start, 0);
		buffer_get_surface(buf, layer_data.s, 0);
		buffer_save(buf, _fpath+"\\"+string(i)+".l");
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
	buffer_save(buf, _fpath+"\\"+string(i)+".l");
	buffer_delete(buf);
	
	save_area_select();
}

function load_all_layers() {
	
	var files = [];
	var file_name = file_find_first(_fpath+"\\*.l", 0);
	
	if file_name == "" return false;
	
	while(file_name != "") {
		array_push(files, file_name);
		file_name = file_find_next();
	}
	file_find_close();
	
	var buf = buffer_create(_paper_res.w * _paper_res.h * 4, buffer_fixed, 1);
	
	for(var i = 0; i < array_length(files); i++) {
		
		var layer_data = _layers[| i];
		layer_data.s = check_surf(layer_data.s, _paper_res.w, _paper_res.h, layer_data.c, layer_data.a);
		
		file_name = _fpath+"\\"+string(i)+".l";
			
		if file_exists(file_name) {
			buf = buffer_load(file_name);
			buffer_set_surface(buf, layer_data.s, 0);
		}
	}
	
	buffer_delete(buf);
	
	load_area_select();
}

function save_area_select() {
	
	var buf = buffer_create(_paper_res.w * _paper_res.h * 4, buffer_fixed, 1);
	buffer_seek(buf, buffer_seek_start, 0);
	buffer_get_surface(buf, _area_surf, 0);
	buffer_save(buf, _fpath+"\\a.s");
	buffer_delete(buf);
	
	var buf = buffer_create(surface_get_width(_copy_surf) * surface_get_height(_copy_surf) * 4, buffer_fixed, 1);
	buffer_seek(buf, buffer_seek_start, 0);
	buffer_get_surface(buf, _copy_surf, 0);
	buffer_save(buf, _fpath+"\\c.s");
	buffer_delete(buf);
}

function load_area_select() {
	
	if file_exists(_fpath+"\\a.s") {
		var buf = buffer_create(_paper_res.w * _paper_res.h * 4, buffer_fixed, 1);
		buf = buffer_load(_fpath+"\\a.s");
		buffer_set_surface(buf, _area_surf, 0);
		buffer_delete(buf);
	}
	if file_exists(_fpath+"\\c.s") {
		var buf = buffer_create(surface_get_width(_copy_surf) * surface_get_height(_copy_surf) * 4, buffer_fixed, 1);
		buf = buffer_load(_fpath+"\\c.s");
		buffer_set_surface(buf, _copy_surf, 0);
		buffer_delete(buf);
	}
}

function save_settings() {
	
	var s = {
		P_RES : _paper_res,
		LANG : _language,
		CURR_T : _current_tool,
		L_ID_C : _layer_id_counter,
		CURR_L : _current_layer,
		L_SEL : { Y : _layer_select.ypos, YS : _layer_select.ypos_smooth },
		BRUSH : { SIZE : _brush.size, FO : _brush.falloff, WEIGHT : _brush.weight, STEP : _brush.step_scale },
		LINE : { POINTS : [], CLOSED : _line.closed, TENSION : _line.tension },
		FILL : { TOL : _fill.tol },
		AREA : { MODE : _area_select.mode, SP : _area_select.start_pos, MX : _area_select.mx, MN : _area_select.mn, COPY_SIZE : _area_select.copy_surf_size },
		PASTE : { A : _pasted_selection.active, POS : _pasted_selection.pos, SIZE : _pasted_selection.size, ROT : _pasted_selection.rot,
			PLACED : _pasted_selection.placed },
		CW : { HSV : [_color_wheel.h, _color_wheel.s, _color_wheel.v], RGBA : [_color_wheel.r, _color_wheel.g, _color_wheel.b, _color_wheel.a],
			HEX : _color_wheel.hex, POS : _color_wheel.pos },
		CAM : { X : cam_x, Y : cam_y, Z : _zoom },
		FILE : { FN : _filename, FPATH: _fpath, LFPATH : _last_fpath },
		LAYERS : [],
	};
	
	foreach "l" in _layers as_list array_push(s.LAYERS, { C : l.c, A : l.a, L_ID : l.l_id, N : l.name, H : l.hidden, LA : l.layer_alpha });
	foreach "p" in _line.points_list as_list array_push(s.LINE.POINTS, p);
	
	var f = file_text_open_write(_fpath+"\\"+_filename+_file_ext);
	file_text_write_string(f, json_stringify(s));
	file_text_close(f);
}

function load() {
	
	var new_path = get_open_filename_ext(_file_ext, "", _last_fpath, _langstr[$ _language].load_caption);
	if new_path == "" return false;
	_fpath = new_path;
	
	var plen = string_length(_fpath)
	var elen = string_length(_file_ext);
	
	if string_copy(_fpath, plen-elen+1, elen) == _file_ext {
		for(var i = plen; i > 0; i--) {
			if string_char_at(_fpath, i) == "\\" {
				_fpath = string_copy(_fpath, 1, i-1);
				break;
			}
		}
	}
	
	for(var i = plen; i > 0; i--) {
		if string_char_at(_fpath, i) == "\\" {
			var new_filename = string_copy(_fpath, i+1, plen-i);
			if string_replace_all(new_filename, " ", "") == "" return false;
			_filename = new_filename;
			break;
		}
	}
	
	load_settings();
	load_all_layers();
	
	set_bottom_right_text("Loaded: "+_fpath, 2);
	
	return true;
}

function load_settings() {
	
	if !file_exists(_fpath+"\\"+_filename+_file_ext) return false;
	
	var f = file_text_open_read(_fpath+"\\"+_filename+_file_ext);
	var s = json_parse(file_text_read_string(f));
	file_text_close(f);
	
	if !is_struct(s) return false;
	
	_paper_res = s.P_RES;
	_language = s.LANG;
	_current_tool = s.CURR_T;
	_layer_id_counter = s.L_ID_C;
	_current_layer = s.CURR_L;
	_layer_select.ypos = s.L_SEL.Y;
	_layer_select.ypos_smooth = s.L_SEL.YS;
	_brush.size = s.BRUSH.SIZE;
	_brush.falloff = s.BRUSH.FO;
	_brush.weight = s.BRUSH.WEIGHT;
	_brush.step_scale = s.BRUSH.STEP;
	show_debug_message(s.LINE.POINTS);
	ds_list_clear(_line.points_list);
	foreach "p" in s.LINE.POINTS as_array ds_list_add(_line.points_list, p);
	_line.closed = s.LINE.CLOSED;
	_line.tension = s.LINE.TENSION;
	_fill.tol = s.FILL.TOL;
	_area_select.mode = s.AREA.MODE;
	_area_select.start_pos = s.AREA.SP;
	_area_select.mx = s.AREA.MX;
	_area_select.mn = s.AREA.MN;
	_area_select.copy_surf_size = s.AREA.COPY_SIZE;
	surface_resize(_copy_surf, _area_select.copy_surf_size[0], _area_select.copy_surf_size[1]);
	_pasted_selection.active = s.PASTE.A;
	_pasted_selection.pos = s.PASTE.POS;
	_pasted_selection.size = s.PASTE.SIZE;
	_pasted_selection.rot = s.PASTE.ROT;
	_pasted_selection.placed = s.PASTE.PLACED;
	_color_wheel.h = s.CW.HSV[0];
	_color_wheel.s = s.CW.HSV[1];
	_color_wheel.v = s.CW.HSV[2];
	_color_wheel.r = s.CW.RGBA[0];
	_color_wheel.g = s.CW.RGBA[1];
	_color_wheel.b = s.CW.RGBA[2];
	_color_wheel.a = s.CW.RGBA[3];
	_color_wheel.hex = s.CW.HEX;
	_color_wheel.pos = s.CW.POS;
	cam_x = s.CAM.X;
	cam_y = s.CAM.Y;
	_zoom = s.CAM.Z;
	_filename = s.FILE.FN;
	_fpath = s.FILE.FPATH;
	_last_fpath = s.FILE.LFPATH;
	
	show_debug_message(s.LAYERS);
	
	for(var i = 0; i < ds_list_size(_layers); i++) input_delete("L_NAME_"+string(_layers[| i].l_id));
	ds_list_clear(_layers);
	
	foreach "lay" in s.LAYERS as_array show_debug_message(string(lay));
	
	for(var i = 0; i < array_length(s.LAYERS); i++) {
		var l = s.LAYERS[i];
		ds_list_add(_layers, { s: -1, c: l.C, a: l.A, l_id: l.L_ID, name: string(l.N), hidden: l.H, layer_alpha: l.LA });
		input_copy("layer name", "L_NAME_"+string(L_ID));
		input_set_text("L_NAME_"+string(l.L_ID), l.N);
	}
	
}
