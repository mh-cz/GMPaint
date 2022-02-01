#region CAMERA

if mouse_check_button(mb_middle) {
	
	if !is_array(cam_prev_mouse_pos) cam_prev_mouse_pos = [mouse_x, mouse_y];
	
	cam_x += cam_prev_mouse_pos[0] - mouse_x;
	cam_y += cam_prev_mouse_pos[1] - mouse_y;
}
else cam_prev_mouse_pos = 0;

var wheel = mouse_wheel_down() - mouse_wheel_up();

_zoom += wheel * 0.2 * _zoom;
cam_x += (cam_x - mouse_x) * (wheel * 0.2);
cam_y += (cam_y - mouse_y) * (wheel * 0.2);

_zoom = clamp(_zoom, 0.02, 3);
cam_x = clamp(cam_x, -screen.w * 0.25, _resolution.w + screen.w * 0.25);
cam_y = clamp(cam_y, -screen.h * 0.25, _resolution.h + screen.h * 0.25);

camera_set_view_pos(view_camera[0], cam_x - screen.w/2 * _zoom, cam_y - screen.h/2 * _zoom);
camera_set_view_size(view_camera[0], screen.w * _zoom, screen.h * _zoom);

#endregion

if keyboard_check(vk_control) {
	if keyboard_check_pressed(ord("S")) {
		save_all_layers();
	}
}
