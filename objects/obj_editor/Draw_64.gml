gpu_set_texfilter(true);

if mouse_check_button_released(mb_left) {
	_mouse_started_on_paper = false;
	_selected_slider = "";
}

_mouse_over_gui = false;

draw_toolbar(35, 35+_bottom_bar.h, 2);

switch(_current_tool) {
	case _tool.brush: options_brush(); break;
	case _tool.line: options_line(); break;
	case _tool.fill: options_fill(); break;
	case _tool.eraser: options_brush(); break;
	//case _tool.pipette: options_pipette(); break;
	case _tool.area_select: options_area(); break;
}

draw_color_picker();
draw_layer_select(screen.w - _layer_select.w - 15, screen.h - _layer_select.h - 15-32 - _bottom_bar.h);
draw_bottom_bar();
draw_upper_bar();
paper_resolution();

_mouse_over_menu = false;
draw_upper_menu();
