get_mouse_pos();

_mask_surf = check_surf(_mask_surf, _paper_res.w, _paper_res.h);
_draw_surf = check_surf(_draw_surf, _paper_res.w, _paper_res.h);
_alpha_surf = check_surf(_alpha_surf, _paper_res.w, _paper_res.h);
_area_surf = check_surf(_area_surf, _paper_res.w, _paper_res.h, c_blue, 1);
_img_ovr_surf = check_surf(_img_ovr_surf, _paper_res.w, _paper_res.h);
_copy_surf = check_surf(_copy_surf, _area_select.copy_surf_size[0], _area_select.copy_surf_size[1]);
_brush_surf = check_surf(_brush_surf, _brush.size, _brush.size);
_brush.brush_surf = check_surf(_brush.brush_surf, _brush.size, _brush.size);
_brush.size_surf = check_surf(_brush.size_surf, _brush.size, _brush.size);

var use_weight = mouse_check_button(mb_left)
				 and (_current_tool == _tool.brush or _current_tool == _tool.eraser);

if _brush.moved {
	_brush.pwmx = _brush.wmx;
	_brush.pwmy = _brush.wmy;
}
_brush.wmx = lerp(_brush.wmx, _mouse.x, use_weight ? _brush.weight * rmspd() : 1);
_brush.wmy = lerp(_brush.wmy, _mouse.y, use_weight ? _brush.weight * rmspd() : 1);
_brush.step = _brush.size * _brush.step_scale;
_brush.pdr_wm = point_direction(_brush.pwmx, _brush.pwmy, _brush.wmx, _brush.wmy);
_brush.pds_wm = point_distance(_brush.pwmx, _brush.pwmy, _brush.wmx, _brush.wmy);
_brush.moved = _brush.pds_wm >= _brush.step;
