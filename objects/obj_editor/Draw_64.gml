gpu_set_texfilter(true);

if mouse_check_button_released(mb_left) {
	_mouse_started_on_paper = false;
	_selected_slider = "";
}
_mouse_over_gui = false;

draw_toolbar(35, 35, 2);
draw_color_picker();
draw_layer_select(screen.w - _layer_select.w - 15, screen.h - _layer_select.h - 15-32);

if mouse_check_button_pressed(mb_left) _mouse_started_on_paper = !_mouse_over_gui;
if mouse_check_button(mb_left) _mouse_over_gui = !_mouse_started_on_paper;

var wx = window_get_x();
var wy = window_get_y();

if point_in_rectangle(display_mouse_get_x(), display_mouse_get_y(), wx, wy, wx+window_get_width(), wy+window_get_height()) {
	if _mouse_over_gui set_cursor(spr_cursor, 1);
	else set_cursor(spr_cursor, 0);
	
	can_reset_cursor = true;
}
else {
	if can_reset_cursor {
		can_reset_cursor = false;
		window_set_cursor(cr_default);
	}
}

draw_sprite(_cursor_spr[0], _cursor_spr[1], device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));
