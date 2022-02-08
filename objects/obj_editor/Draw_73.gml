var off = (_brush.size % 2 == 1) ? 0.5 : 1;

switch(_current_tool) {
	
	case _tool.fill:
	
		draw_set_color(rgba2c(_brush.col, 255));
		draw_rectangle(_mouse.x, _mouse.y, _mouse.x, _mouse.y, false);
		break;
	
	case _tool.brush:
	case _tool.eraser:
	case _tool.line:
	
		if !mouse_check_button(mb_left) and surface_exists(_brush.brush_surf) {
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			draw_surface(_brush.brush_surf, _mouse.x - _brush.size div 2, _mouse.y - _brush.size div 2);
			gpu_set_blendmode(bm_normal);
		}
		
		draw_set_color(c_black);
		draw_rectangle(0, 0, _paper_res.w - 1, _paper_res.h - 1, true);
		draw_rectangle(_mouse.x, _mouse.y, _mouse.x, _mouse.y, true);
		draw_circle(_brush.wmx - off, _brush.wmy - off, _brush.size/2, true);
		
		if _brush.weight < 0.5 draw_line(_mouse.x - off, _mouse.y - off, _brush.wmx - off, _brush.wmy - off);
		break;
}
