function init() {
	
	with(id) {
		
		room_speed = 60;
	
		globalvar _brush;
		globalvar _layers;
		globalvar _current_layer;
		globalvar _paper_res;
		globalvar _mask_surf;
		globalvar _alpha_surf;
		globalvar _draw_surf;
		globalvar _brush_surf;
		globalvar _img_ovr_surf;
		globalvar _current_tool;
		globalvar _zoom;
		globalvar _cursor_spr;
		globalvar _line;
		globalvar _fill;
		globalvar _pipette;
		globalvar _mouse_over_gui;
		globalvar _color_wheel;
		globalvar _mouse_started_on_paper;
		globalvar _selected_slider;
		globalvar _selected_input;
		globalvar _filename;
		globalvar _file_ext;
		globalvar _mouse;
		globalvar _layer_select;
		globalvar _layer_id_counter;
		globalvar _bottom_bar;
		globalvar _upper_bar;
		globalvar _menu_list;
		globalvar _language;
		globalvar _langstr;
		globalvar _sel_menu_opt;
		globalvar _mouse_over_menu;
		
		enum _tool { none = -1, brush = 0, line = 1, fill = 2, eraser = 3, pipette = 4, area_select = 5 };
		
		_language = "cz";
		
		lang_strings();
		input_init();
		make_inputs();
		foreach_init();
	
		_paper_res = { w: 1280, h: 720 };
		
		screen = { w: window_get_width(), h: window_get_height() };
		window_resize();
	
		_current_tool = _tool.brush;
		_layers = ds_list_create();
		_layer_id_counter = 0;
		_current_layer = -1;
		
		layer_add(c_grey, 1);
		
		_layer_select = { surf: -1, w: 200, h: 400, ypos: 0, ypos_smooth: 0 };
	
		_brush = { size: 20, brush_surf: -1, size_surf: -1, col: [1, 1, 1, 1], falloff: 1.2, tex: -1, tex_mask: -1,
				   step: 0, step_scale: .15, weight: 1, wmx: 0, wmy: 0, pwmx: 0, pwmy: 0, 
				   pds_wm: 0, pdr_wm: 0, moved: false };
	
		_line = { points_list: ds_list_create(), grabbed: -1, tension: 0, closed: false };
	
		_fill = { surf: -1, comp_surf: -1, copy_surf: -1, find_col_surf: -1, one_px_surf: -1,
				  tol: 10, phase: 0, start_col: [0,0,0,0], start_pos: [0,0], buf: -1 };
	
		_pipette = { buf_list: ds_list_create() };
		
		_mask_surf = -1;
		_draw_surf = -1;
		_alpha_surf = -1;
		_brush_surf = -1;
		_img_ovr_surf = -1;
	
		_color_wheel = { surf: -1, size_surf: -1, h: 0, s: 0, v: 1, r: 1, g: 1, b: 1, a: 1, hex: "#FFFFFF",
						 pos: [-1, -1], msi: false, prev_rgba: [1, 1, 1, 1], wy: -0.5 };
	
		_bottom_bar = { h: 20, left_text: "", right_text: "" };
		_upper_bar = { h: 24 };
		
		create_camera();
		cam_x = _paper_res.w/2;
		cam_y = _paper_res.h/2;
		cam_prev_mouse_pos = 0;
		_zoom = 1;
		
		_mouse = { x: 0, y: 0, xfloat: 0, yfloat: 0 };
	
		draw_set_circle_precision(32);
	
		_mouse_over_gui = false;
		_mouse_started_on_paper = false;
	
		_selected_input = "";
		_selected_slider = "";
	
		set_cursor(spr_cursor, 1);
	
		_filename = "new_paper";
		_file_ext = ".gmp";
	
		can_reset_cursor = false;
		
		_menu_list = ds_list_create();
		make_menus();
		_sel_menu_opt = "";
		_mouse_over_menu = false;
	}
}

function get_mouse_pos() {
	_mouse.xfloat = device_mouse_x_to_gui(0) * _zoom + camera_get_view_x(view_camera[0]);
	_mouse.yfloat = device_mouse_y_to_gui(0) * _zoom + camera_get_view_y(view_camera[0]);
	_mouse.x = floor(_mouse.xfloat);
	_mouse.y = floor(_mouse.yfloat);
}

function set_cursor(spr, img) {
	window_set_cursor(cr_none);
	_cursor_spr = [spr, img];
}

function c2rgba(c) {
	return [ (c >> 0) & 0xff, (c >> 8) & 0xff, (c >> 16) & 0xff, (c >> 24) & 0xff ];
}

function rgba2c(rgba, mult = 255, prem = false) {
	return prem ? make_color_rgb(rgba[0] * mult * rgba[3], rgba[1] * mult * rgba[3], rgba[2] * mult * rgba[3])
				: make_color_rgb(rgba[0] * mult, rgba[1] * mult, rgba[2] * mult);
}

function prem_c(c, a) {
	var rgba = c2rgba(c);
	return make_color_rgb(rgba[0] * a, rgba[1] * a, rgba[2] * a);
}

function create_camera() {
	view_camera[0] = camera_create_view(0, 0, view_wport[0], view_hport[0], 0, noone, -1, -1, -1, -1);
}

function window_resize() {
	screen.w = window_get_width();
	screen.h = window_get_height();
	
	if screen.w > 10 and screen.h > 10 {
		view_wport[0] = screen.w;
		view_hport[0] = screen.h;
		display_set_gui_size(screen.w, screen.h);	
		surface_resize(application_surface, screen.w, screen.h);
	}
}

function clear_surf(s) {
	if !is_array(s) {
		surface_set_target(s);
		draw_clear_alpha(c_black, 0);
		surface_reset_target();
	}
	else for(var i = 0; i < array_length(s); i++) {
		surface_set_target(s[i]);
		draw_clear_alpha(c_black, 0);
		surface_reset_target();
	}
}

function free_surf(s) {
	if !is_array(s) {
		if surface_exists(s) surface_free(s);
	}
	else for(var i = 0; i < array_length(s); i++) {
		if surface_exists(s[i]) surface_free(s[i]);
	}
}

function layer_add(col = c_black, alpha = 0) {
	
	ds_list_insert(_layers, ++_current_layer, {
		s: check_surf(-1, _paper_res.w, _paper_res.h, col, alpha), c: col, a: alpha,
		l_id: _layer_id_counter, name: string(_layer_id_counter), hidden: false, layer_alpha: 1 }
	);
	
	input_copy("layer name", "L_NAME_"+string(_layer_id_counter));
	input_set_text("L_NAME_"+string(_layer_id_counter), "New Layer");
	
	_layer_id_counter++;
}

function layer_delete(l) {
	input_delete("L_NAME_"+string(_layers[| l].l_id));
	ds_list_delete(_layers, l);
}

function check_surf(s, w, h, c = c_black, a = 0) {
	if !surface_exists(s) {
		s = surface_create(w, h);
		surface_set_target(s);
		draw_clear_alpha(prem_c(c, a), a);
		surface_reset_target();
	}
	return s;
}

function rmspd() {
	return 60 / max(60, room_speed);
}
