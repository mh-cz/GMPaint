function import() {
	
	var path = get_open_filename_ext("*.jpg; *.jpeg, *.png", "", _last_fpath, "Import");
	if path == "" return false;
	
	var img = sprite_add(path, 1, false, false, 0, 0);
	var w = sprite_get_width(img);
	var h = sprite_get_height(img);
	
	if w < 1 or h < 1 {
		sprite_delete(img);
		return false;
	}
	
	surface_resize(_copy_surf, w, h);
	surface_set_target(_copy_surf);
	shader_set(shd_premultiply_alpha);
	draw_sprite(img, 0, 0, 0);
	shader_reset();
	surface_reset_target();
	
	sprite_delete(img);
	
	_area_select.copy_surf_size = [w, h];
	_pasted_selection.pos = [_mouse.x, _mouse.y];
	_pasted_selection.size = [_area_select.copy_surf_size[0], _area_select.copy_surf_size[1]];
	_pasted_selection.rot = 0;
	_pasted_selection.active = true;
	
	set_bottom_right_text("Imported: \""+path+"\"", 2);
}

function export() {
	
	var path = get_save_filename_ext("*.png", (_filename == "" ? "untitled" : _filename) + ".png", _last_fpath, "Export");
	if path == "" return false;
	
	gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
	surface_set_target(_draw_surf);
	draw_clear_alpha(c_black, 0);
			
	for(var i = 0; i < ds_list_size(_layers); i++) {
		var l = _layers[| i];
		if !l.hidden draw_surface_ext(l.s, 0, 0, 1, 1, 0, make_color_hsv(0, 0, l.layer_alpha*255), l.layer_alpha);
	}
	
	surface_reset_target();
	gpu_set_blendmode(bm_normal);
	
	surface_save(_draw_surf, path);
	clear_surf(_draw_surf);
	
	set_bottom_right_text("Exported as: \""+path+"\"", 2);
}

function export_layer() {
	
	var path = get_save_filename_ext("*.png", (_filename == "" ? "untitled" : _filename) + ".png", _last_fpath, "Export PNG");
	if path == "" return false;
	
	gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
	surface_set_target(_draw_surf);
	draw_clear_alpha(c_black, 0);
			
	var l = _layers[| _current_layer];
	draw_surface_ext(l.s, 0, 0, 1, 1, 0, make_color_hsv(0, 0, l.layer_alpha*255), l.layer_alpha);
	
	surface_reset_target();
	gpu_set_blendmode(bm_normal);
	
	surface_save(_draw_surf, path);
	clear_surf(_draw_surf);
	
	set_bottom_right_text("Exported as: \""+path+"\"", 2);
}

function export_gif() {
	
	var path = get_save_filename_ext("*.gif", (_filename == "" ? "untitled" : _filename) + ".gif", _last_fpath, "Export GIF");
	if path == "" return false;
	
	var g = gif_open(_paper_res.w, _paper_res.h);
	
	for(var i = 0; i < ds_list_size(_layers); i++) {
		var l = _layers[| i];
		if l.hidden continue;
		
		gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
		surface_set_target(_draw_surf);
		draw_clear_alpha(c_black, 0);
		draw_surface_ext(l.s, 0, 0, 1, 1, 0, make_color_hsv(0, 0, l.layer_alpha*255), l.layer_alpha);
		surface_reset_target();
		gpu_set_blendmode(bm_normal);
		
		gif_add_surface(g, _draw_surf, 1/30);
	}
	
	clear_surf(_draw_surf);
	
	gif_save(g, path);
	set_bottom_right_text("Exported as: \""+path+"\"", 2);
}
