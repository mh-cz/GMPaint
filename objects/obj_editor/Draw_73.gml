var off = (_brush.size % 2 == 1) ? 0.5 : 1;

draw_set_color(c_gray);
draw_rectangle(0, 0, _paper_res.w - 1, _paper_res.h - 1, true);

switch(_current_tool) {
	
	case _tool.fill:
		
		draw_set_color(rgba2c(_brush.col, 255));
		draw_rectangle(_mouse.x, _mouse.y, _mouse.x, _mouse.y, false);
		break;
	
	case _tool.brush:
	case _tool.eraser:
	case _tool.line:
	case _tool.area_select:
	
		if _current_tool == _tool.area_select and _area_select.mode != 2 break;
	
		if (!mouse_check_button(mb_left) or _mouse_over_gui) and surface_exists(_brush.brush_surf) {
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			draw_surface_ext(_brush.brush_surf, _mouse.x - _brush.size div 2, _mouse.y - _brush.size div 2,
							 1, 1, 0, rgba2c(_brush.col, 255, true), _brush.col[3]);
			gpu_set_blendmode(bm_normal);
		}
		
		draw_set_color(c_black);
		draw_rectangle(_mouse.x, _mouse.y, _mouse.x, _mouse.y, true);
		draw_circle(_brush.wmx - off, _brush.wmy - off, _brush.size/2, true);
		
		if _brush.weight < 0.5 draw_line(_mouse.x - off, _mouse.y - off, _brush.wmx - off, _brush.wmy - off);
		break;
}

shader_set(shd_area_outline);
shader_set_uniform_f_array(shader_get_uniform(shd_area_outline, "texel_size"), [1/_paper_res.w, 1/_paper_res.h]);
shader_set_uniform_f(shader_get_uniform(shd_area_outline, "time"), get_timer() * 0.000001);
draw_surface(_area_surf, 0, 0);
shader_reset();

paper_resolution_drag();
