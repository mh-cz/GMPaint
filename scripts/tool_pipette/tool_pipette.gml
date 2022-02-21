function tool_pipette() {
	
	if mouse_check_button(mb_left) and !_mouse_over_gui {
		
		var c = surface_getpixel_ext(_pipette.buf_list[| _current_layer], _mouse.x, _mouse.y);
		
		var rgba = c2rgba(c);
		
		_color_wheel.r = rgba[0]/255;
		_color_wheel.g = rgba[1]/255;
		_color_wheel.b = rgba[2]/255;
		_color_wheel.a = rgba[3]/255;
		_color_wheel.h = color_get_hue(c)/255;
		_color_wheel.s = color_get_saturation(c)/255;
		_color_wheel.v = color_get_value(c)/255;
		
		_color_wheel.pos = [
			150/2 + lengthdir_x(_color_wheel.s * 150/2, _color_wheel.h * -360),
			150/2 + lengthdir_y(_color_wheel.s * 150/2, _color_wheel.h * -360)
		];
		
		set_text_from_sliders(true);
	}
}
