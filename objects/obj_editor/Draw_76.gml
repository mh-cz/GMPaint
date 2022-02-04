get_mouse_pos();

_mask_surf = check_surf(_mask_surf, _paper_res.w, _paper_res.h);
_draw_surf = check_surf(_draw_surf, _paper_res.w, _paper_res.h);
_alpha_surf = check_surf(_alpha_surf, _paper_res.w, _paper_res.h);
_img_ovr_surf = check_surf(_img_ovr_surf, _paper_res.w, _paper_res.h);
_brush_surf = check_surf(_brush_surf, _brush.size, _brush.size);

var use_weight = device_mouse_check_button(0, mb_left)
				 and (_tool_current == _tools.brush or _tool_current == _tools.eraser);

_brush.brush_surf = check_surf(_brush.brush_surf, _brush.size, _brush.size);
_brush.size_surf = check_surf(_brush.size_surf, _brush.size, _brush.size);
_brush.pwmx = _brush.wmx;
_brush.pwmy = _brush.wmy;
_brush.wmx = lerp(_brush.wmx, _mouse.x, use_weight ? _brush.weight * rmspd() : 1);
_brush.wmy = lerp(_brush.wmy, _mouse.y, use_weight ? _brush.weight * rmspd() : 1);
_brush.step = _brush.size * _brush.step_scale;
_brush.pdr_m = point_direction(_brush.pmx, _brush.pmy, _mouse.x, _mouse.y);
_brush.pds_m = point_distance(_brush.pmx, _brush.pmy, _mouse.x, _mouse.y);
_brush.pdr_wm = point_direction(_brush.pwmx, _brush.pwmy, _brush.wmx, _brush.wmy);
_brush.pds_wm = point_distance(_brush.pwmx, _brush.pwmy, _brush.wmx, _brush.wmy);
_brush.pmx = _mouse.x;
_brush.pmy = _mouse.y;
_brush.moved = floor(_brush.wmx) != floor(_brush.pwmx) or floor(_brush.wmy) != floor(_brush.pwmy);
