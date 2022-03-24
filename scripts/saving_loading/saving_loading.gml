function save(as = false) { // SAVE
	
	if as {
		obj_editor.old = [_fpath, _filename];
		_fpath = "";
		_filename = "";
	}
	
	if _filename == "" {
		var new_path = get_save_filename_ext("*"+_file_ext, _langstr[$ _language].new_file+_file_ext, _last_fpath, _langstr[$ _language].save_caption);
		if new_path == "" {
			if as {
				_fpath = obj_editor.old[0];
				_filename = obj_editor.old[1];
			}
			return false;
		}
		_fpath = new_path;
		
		var plen = string_length(_fpath);
		var elen = string_length(_file_ext);

		if string_copy(_fpath, plen-elen+1, elen) == _file_ext {
			_fpath = string_delete(_fpath, plen-elen+1, elen);
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
	
	obj_editor.alarm[as ? 3 : 1] = 2;
}

function save_into_file(path = _fpath, ext = _file_ext) {
	
	var s = {
		P_RES: _paper_res,
		LANG: _language,
		CURR_T: _current_tool,
		L_ID_C: _layer_id_counter,
		CURR_L: _current_layer,
		L_SEL: { Y: _layer_select.ypos, YS: _layer_select.ypos_smooth },
		BRUSH: { SIZE: _brush.size, FO: _brush.falloff, WEIGHT: _brush.weight, STEP: _brush.step_scale },
		LINE: { POINTS: [], CLOSED: _line.closed, TENSION: _line.tension },
		FILL: { TOL: _fill.tol },
		AREA: { MODE: _area_select.mode, SP: _area_select.start_pos, MX: _area_select.mx, MN: _area_select.mn, COPY_SIZE: _area_select.copy_surf_size },
		PASTE: { A: _pasted_selection.active, POS: _pasted_selection.pos, SIZE: _pasted_selection.size, ROT: _pasted_selection.rot,
			PLACED: _pasted_selection.placed },
		CW: { HSV: [_color_wheel.h, _color_wheel.s, _color_wheel.v], RGBA: [_color_wheel.r, _color_wheel.g, _color_wheel.b, _color_wheel.a],
			HEX: _color_wheel.hex, POS: _color_wheel.pos },
		CAM: { POS: [obj_editor.cam_x, obj_editor.cam_y], Z: _zoom },
		FILE: { FN: _filename, FPATH: _fpath, LFPATH: _last_fpath },
		BUFS: [],
	};
	
	foreach "p" in _line.points_list as_list array_push(s.LINE.POINTS, p);
	
	var struct_space = 2048;
	
	var bs = buffer_create(struct_space, buffer_fixed, 1); // buffer struct
	var bl = buffer_create(_paper_res.w * _paper_res.h * 4, buffer_fixed, 1); // buffer layer
	var bc = buffer_create(surface_get_width(_copy_surf) * surface_get_height(_copy_surf) * 4, buffer_fixed, 1); // buffer copy surf
	var big_buf = buffer_create(0, buffer_grow, 1); // save buffer
	
	var size = buffer_get_size(bl);
	
	foreach "l" in _layers as_list {
		buffer_get_surface(bl, l.s, 0);
		buffer_copy(bl, 0, size, big_buf, buffer_get_size(big_buf) + struct_space);
		struct_space = 0; // offset just once
		array_push(s.BUFS, { SIZE: size, TYPE: "L", C: l.c, A: l.a, L_ID: l.l_id, N: l.name, H: l.hidden, LA: l.layer_alpha });
	}
	
	buffer_get_surface(bl, _area_surf, 0);
	buffer_copy(bl, 0, size, big_buf, buffer_get_size(big_buf) + struct_space);
	struct_space = 0; // just in case no layers
	array_push(s.BUFS, { SIZE: size, TYPE: "A" });
	
	buffer_get_surface(bc, _copy_surf, 0);
	size = buffer_get_size(bc);
	buffer_copy(bc, 0, size, big_buf, buffer_get_size(big_buf));
	array_push(s.BUFS, { SIZE: size, TYPE: "C" });
	
	buffer_write(bs, buffer_string, json_stringify(s));
	buffer_copy(bs, 0, buffer_get_size(bs), big_buf, 0);
	
	buffer_save(big_buf, path + ext);
	
	buffer_delete(bs);
	buffer_delete(bl);
	buffer_delete(bc);
	buffer_delete(big_buf);
	
	return true;
}

function load(path = "") { // OPEN
	
	if path == "" {
		path = get_open_filename_ext("*"+_file_ext+";, *.jpg; *.jpeg; *.png", "", _last_fpath, _langstr[$ _language].load_caption);
		if path == "" return false;
	}
	_fpath = path;
	
	var plen = string_length(_fpath)
	var elen = 0;
	
	for(var i = plen; i > 0; i--) {
		elen++;
		if string_char_at(_fpath, i) == "." {
			_loaded_ext = string_copy(_fpath, i, i+elen);
			if string_length(_loaded_ext) < 2 return false;
			_fpath = string_delete(_fpath, plen-elen+1, elen);
			break;
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
	
	obj_editor.alarm[2] = 2;
}

function load_from_file(path = _fpath, ext = _loaded_ext) {
	
	path += ext;
	
	if !file_exists(path) { set_bottom_right_text("NO FILE: \""+path+"\"", 2); return false; }
	
	var load_gmp = function(path) {
		
		var big_buf = buffer_load(path);
		var bs = buffer_create(2048, buffer_fixed, 1);
		var bl = -1;
		var bc = -1;
		var ba = -1;	
	
		var size = buffer_get_size(bs);
		var start = 0;
	
		buffer_copy(big_buf, start, size, bs, 0);
		start += size;
	
		var s = json_parse(buffer_read(bs, buffer_string));
	
		if !is_struct(s) { set_bottom_right_text("FILE \""+path+"\" IS DAMAGED", 2); return false; }
	
		_paper_res = s.P_RES;
		_language = s.LANG;
		_current_tool = s.CURR_T;
		_layer_id_counter = s.L_ID_C;
		_current_layer = s.CURR_L;
		_layer_select.ypos = s.L_SEL.Y;
		_layer_select.ypos_smooth = s.L_SEL.YS;
		_brush.size = s.BRUSH.SIZE;
		surface_resize(_brush.size_surf, _brush.size, _brush.size);
		surface_resize(_brush.brush_surf, _brush.size, _brush.size);
		_brush.falloff = s.BRUSH.FO;
		_brush.weight = s.BRUSH.WEIGHT;
		_brush.step_scale = s.BRUSH.STEP;
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
		cam_x = s.CAM.POS[0];
		cam_y = s.CAM.POS[1];
		_zoom = s.CAM.Z;
		_filename = s.FILE.FN;
		_fpath = s.FILE.FPATH;
		_last_fpath = s.FILE.LFPATH;
		
		foreach "l" in _layers as_list input_delete("L_NAME_"+string(l.l_id));
		ds_list_clear(_layers);
		
		foreach "b" in s.BUFS as_array switch(b.TYPE) {
		
			case "L":
				ds_list_add(_layers, { s: surface_create(_paper_res.w, _paper_res.h), 
					c: b.C, a: b.A, l_id: b.L_ID, name: string(b.N), hidden: b.H, layer_alpha: b.LA });
				input_copy("layer name", "L_NAME_"+string(b.L_ID));
				input_set_text("L_NAME_"+string(b.L_ID), b.N);
				
				if bl == -1 bl = buffer_create(b.SIZE, buffer_fixed, 1);
				buffer_copy(big_buf, start, b.SIZE, bl, 0);
				buffer_set_surface(bl, _layers[| ds_list_size(_layers)-1].s, 0);
				start += b.SIZE;
				break;
			
			case "C":
				bc = buffer_create(b.SIZE, buffer_fixed, 1);
				buffer_copy(big_buf, start, b.SIZE, bc, 0);
				buffer_set_surface(bc, _copy_surf, 0);
				start += b.SIZE;
				break;
			
			case "A":
				ba = buffer_create(b.SIZE, buffer_fixed, 1);
				buffer_copy(big_buf, start, b.SIZE, ba, 0);
				buffer_set_surface(ba, _area_surf, 0);
				start += b.SIZE;
				break;
		}
	
		if bl != -1 buffer_delete(bl);
		if bc != -1 buffer_delete(bc);
		if ba != -1 buffer_delete(ba);
		buffer_delete(bs);
		buffer_delete(big_buf);
		
		return true;
	}
	
	var load_image = function(path) {
		
		var img = sprite_add(path, 1, false, false, 0, 0);
		var w = sprite_get_width(img);
		var h = sprite_get_height(img);
		
		if w == 0 or h == 0 {
			sprite_delete(img);
			return false;
		}
		
		foreach "l" in _layers as_list input_delete("L_NAME_"+string(l.l_id));
		ds_list_clear(_layers);
		_layer_id_counter = 0;
		_current_layer = -1;
		ds_list_clear(_line.points_list);
		
		_paper_res.w = w;
		_paper_res.h = h;
		
		layer_add();
		
		surface_set_target(_layers[| _current_layer].s);
		shader_set(shd_premultiply_alpha);
		draw_sprite(img, 0, 0, 0);
		shader_reset();
		surface_reset_target();
		
		surface_resize(_mask_surf, _paper_res.w, _paper_res.h);		
		surface_resize(_draw_surf, _paper_res.w, _paper_res.h);		
		surface_resize(_alpha_surf, _paper_res.w, _paper_res.h);		
		surface_resize(_img_ovr_surf, _paper_res.w, _paper_res.h);		
		surface_resize(_area_surf, _paper_res.w, _paper_res.h);	
		clear_area_select();
		
		_paper_res_drag.size[0] = _paper_res.w;
		_paper_res_drag.size[1] = _paper_res.h;
		input_set_text("paper w", _paper_res_drag.size[0]);
		input_set_text("paper h", _paper_res_drag.size[1]);
		
		sprite_delete(img);
		
		return true;
	}
	
	switch(_loaded_ext) {
		case ".gmp":
			var status = load_gmp(path);
			_loaded_ext = _file_ext;
			quicksave();
			return status;
		case ".jpg":
		case ".jpeg":
		case ".png":
			var status = load_image(path);
			_loaded_ext = _file_ext;
			quicksave();
			return status;
	}
}

// window resize
function quicksave() {
	save_into_file("quick", _file_ext);
}

function quickload() {
	load_from_file("quick", _file_ext);
}
