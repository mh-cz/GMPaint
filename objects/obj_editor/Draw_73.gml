var off = 1 - (_brush.size % 2);

switch(_tool_current) {
	
	case _tools.fill:
	
		draw_set_color(rgba2c(_brush.col, 255));
		draw_rectangle(_mouse.x, _mouse.y, _mouse.x, _mouse.y, false);
		break;
	
	case _tools.brush:
	case _tools.eraser:
	case _tools.line:
	
		if !mouse_check_button(mb_left) and surface_exists(_brush.brush_surf) {
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			draw_surface(_brush.brush_surf, _mouse.x - _brush.size div 2, _mouse.y - _brush.size div 2);
			gpu_set_blendmode(bm_normal);
		}
	
		draw_set_color(c_dkgray);
		draw_rectangle(0, 0, _resolution.w - 1, _resolution.h - 1, true);
		draw_rectangle(_mouse.x, _mouse.y, _mouse.x, _mouse.y, true);
		draw_circle(_brush.wmx - off, _brush.wmy - off, _brush.size div 2, true);

		if _brush.weight < 0.5 draw_line(_mouse.x - 0.5, _mouse.y - 0.5, _brush.wmx - 0.5, _brush.wmy - 0.5);
		break;
}
