function init() {
	
	room_speed = 60;
	
	globalvar _brush;
	globalvar _layers;
	globalvar _current_layer;
	globalvar _resolution;
	globalvar _mask_surf;
	globalvar _alpha_surf;
	globalvar _draw_surf;
	globalvar _brush_surf;
	globalvar _img_ovr_surf;
	globalvar _tool_current;
	globalvar _zoom;
	globalvar _cursor_spr;
	globalvar _line;
	globalvar _fill;
	globalvar _mouse_over_gui;
	globalvar _color_wheel;
	globalvar _mouse_started_on_paper;
	globalvar _selected_slider;
	globalvar _selected_input;
	globalvar _filename;
	globalvar _filename_ext;
	globalvar _mouse;
	
	enum _tools { none = -1, brush = 0, line = 1, fill = 2, eraser = 3 };
	
	_resolution = { w: 1280, h: 720 };
	screen = { w: window_get_width(), h: window_get_height() };
	
	_tool_current = _tools.brush;
	_layers = ds_list_create();
	_current_layer = layer_add(_resolution.w, _resolution.h, c_grey, 1);
	
	_brush = { size: 19, brush_surf: -1, size_surf: -1, col: [1, 1, 1, 1], falloff: 1, tex: -1, tex_mask: -1,
			   step: 0, step_scale: .1, weight: 0.1, wmx: 0, wmy: 0, pmx: 0, pmy: 0, pwmx: 0, pwmy: 0, 
			   pds_wm: 0, pdr_wm: 0, pds_m: 0, pdr_m: 0, moved: false };
	
	_line = { points_list: ds_list_create(), grabbed: -1, tension: 0, closed: false };
	
	_fill = { surf: -1, comp_surf: -1, copy_surf: -1, find_col_surf: -1, one_px_surf: -1, tol: 100, phase: 0, start_col: [0,0,0,0], start_pos: [0,0] };
	
	_mask_surf = -1;
	_draw_surf = -1;
	_alpha_surf = -1;
	_brush_surf = -1;
	_img_ovr_surf = -1;
	
	_color_wheel = { surf: -1, size_surf: -1, h: 0, s: 0, v: 1, r: 1, g: 1, b: 1, a: 1, hex: "#FFFFFF", pos: [-1, -1], msi: false, 
					 prev_rgba: [1, 1, 1, 1], wy: -0.5 };
	
	set_camera();
	cam_x = _resolution.w/2;
	cam_y = _resolution.h/2;
	cam_prev_mouse_pos = 0;
	_zoom = 1;
	
	_mouse = { x: 0, y: 0, xfloat: 0, yfloat: 0 };
	
	set_cursor(spr_cursor_cross);
	draw_set_circle_precision(32);
	
	_mouse_over_gui = false;
	_mouse_started_on_paper = false;
	
	input_init();
	make_inputs();
	_selected_input = "";
	_selected_slider = "";
	
	foreach_init();
	
	_filename = "new_paper";
	_filename_ext = ".gmp";
}

function get_mouse_pos() {
	_mouse.xfloat = device_mouse_x_to_gui(0) * _zoom + camera_get_view_x(view_camera[0]);
	_mouse.yfloat = device_mouse_y_to_gui(0) * _zoom + camera_get_view_y(view_camera[0]);
	_mouse.x = floor(_mouse.xfloat);
	_mouse.y = floor(_mouse.yfloat);
}

function set_cursor(spr) {
	window_set_cursor(cr_none);
	_cursor_spr = spr;
}

function c2rgba(c) {
	return [ (c >> 0) & 0xff, (c >> 8) & 0xff, (c >> 16) & 0xff, (c >> 24) & 0xff ];
}

function rgba2c(rgba, mult = 255, prem = false) {
	var a = rgba[3];
	return prem ? make_color_rgb(rgba[0] * mult * a, rgba[1] * mult * a, rgba[2] * mult * a)
				: make_color_rgb(rgba[0] * mult,	 rgba[1] * mult,	 rgba[2] * mult);
}

function prem_c(c, a) {
	var c_arr = c2rgba(c);
	return make_color_rgb(c_arr[0] * a, c_arr[1] * a, c_arr[2] * a);
}

function set_camera() {
	view_camera[0] = camera_create_view(0, 0, view_wport[0], view_hport[0], 0, noone, -1, -1, -1, -1);
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
		surface_free(s);
	}
	else for(var i = 0; i < array_length(s); i++) {
		surface_free(s[i]);
	}
}

function layer_add(w, h, col = c_black, alpha = 0) {
	var pos = ds_list_size(_layers);
	ds_list_add(_layers, { s: check_surf(-1, w, h, col, alpha), c: col, a: alpha });
	return pos;
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
