_mask_surf = check_surf(_mask_surf, _resolution.w, _resolution.h);
_draw_surf = check_surf(_draw_surf, _resolution.w, _resolution.h);
_alpha_surf = check_surf(_alpha_surf, _resolution.w, _resolution.h);
_img_ovr_surf = check_surf(_img_ovr_surf, _resolution.w, _resolution.h);
_brush_surf = check_surf(_brush_surf, _brush.size, _brush.size);

var use_weight = device_mouse_check_button(0, mb_left) and _tool_current == _tools.brush;

_brush.predraw_surf = check_surf(_brush.predraw_surf, _brush.size, _brush.size);
_brush.size_surf = check_surf(_brush.size_surf, _brush.size, _brush.size);
_brush.pwmx = _brush.wmx;
_brush.pwmy = _brush.wmy;
_brush.wmx = lerp(_brush.wmx, mouse_x, use_weight ? _brush.weight * rmspd() : 1);
_brush.wmy = lerp(_brush.wmy, mouse_y, use_weight ? _brush.weight * rmspd() : 1);
_brush.step = _brush.size * _brush.step_scale;
_brush.pdr_m = point_direction(_brush.pmx, _brush.pmy, mouse_x, mouse_y);
_brush.pds_m = point_distance(_brush.pmx, _brush.pmy, mouse_x, mouse_y);
_brush.pdr_wm = point_direction(_brush.pwmx, _brush.pwmy, _brush.wmx, _brush.wmy);
_brush.pds_wm = point_distance(_brush.pwmx, _brush.pwmy, _brush.wmx, _brush.wmy);
_brush.pmx = mouse_x;
_brush.pmy = mouse_y;
_brush.moved = floor(_brush.wmx) != floor(_brush.pwmx) or floor(_brush.wmy) != floor(_brush.pwmy);
