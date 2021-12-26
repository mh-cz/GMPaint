if mouse_check_button_released(mb_left) {
	_mouse_started_on_paper = false;
	_selected_slider = "";
}
_mouse_over_gui = false;

draw_toolbar(35, 35, 2);
draw_color_picker();

if mouse_check_button_pressed(mb_left) _mouse_started_on_paper = !_mouse_over_gui;
if mouse_check_button(mb_left) _mouse_over_gui = !_mouse_started_on_paper;

draw_sprite(_cursor_spr, 0, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));


