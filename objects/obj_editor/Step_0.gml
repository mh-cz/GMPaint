#region CAMERA

if mouse_check_button(mb_middle) {
	
	if !is_array(cam_prev_mouse_pos) cam_prev_mouse_pos = [_mouse.x, _mouse.y];
	
	cam_x += cam_prev_mouse_pos[0] - _mouse.x;
	cam_y += cam_prev_mouse_pos[1] - _mouse.y;
}
else cam_prev_mouse_pos = 0;

var wheel = mouse_wheel_down() - mouse_wheel_up();

if wheel != 0 and (!_mouse_over_gui or _paper_res_drag.action != 0) {
	
	_zoom += _zoom * wheel * 0.2;
	
	cam_x += (cam_x - _mouse.x) * (wheel * 0.2);
	cam_y += (cam_y - _mouse.y) * (wheel * 0.2);
	
	_zoom = clamp(_zoom, 0.02, 3);
	cam_x = round(clamp(cam_x, -screen.w * 0.25, _paper_res.w + screen.w * 0.25));
	cam_y = round(clamp(cam_y, -screen.h * 0.25, _paper_res.h + screen.h * 0.25));
}

camera_set_view_pos(view_camera[0], cam_x - screen.w/2 * _zoom, cam_y - screen.h/2 * _zoom);
camera_set_view_size(view_camera[0], screen.w * _zoom, screen.h * _zoom);

#endregion

if keyboard_check(vk_control) {
		 if keyboard_check_pressed(ord("S")) save();
	else if keyboard_check_pressed(ord("A")) clear_area_select();
	else if keyboard_check_pressed(ord("C")) area_copy();
	else if keyboard_check_pressed(ord("V")) area_paste();
	else if keyboard_check_pressed(ord("Z")) undo();
}

if mouse_check_button_pressed(mb_left) and !_mouse_over_gui {
	last_click_pos = [_mouse.x, _mouse.y];
}
else if mouse_check_button_released(mb_left) and _current_tool == _tool.area_select {
	if last_click_pos[0] == _mouse.x and last_click_pos[1] == _mouse.y
	and !point_in_rectangle(_mouse.x, _mouse.y, 0, 0, _paper_res.w, _paper_res.h) {
		clear_area_select();
	}
}

var wx = window_get_x();
var wy = window_get_y();

if point_in_rectangle(display_mouse_get_x(), display_mouse_get_y(), wx, wy, wx+window_get_width(), wy+window_get_height()) {
	if _mouse_over_gui set_cursor(spr_cursor, 1);
	else set_cursor(spr_cursor, 0);
	can_reset_cursor = true;
}
else if can_reset_cursor {
	can_reset_cursor = false;
	window_set_cursor(cr_default);
}

window_set_caption("GMPaint > "+(_filename != "" ? _filename : "untitled"));
