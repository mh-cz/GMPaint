draw_set_color(c_dkgray);
draw_rectangle(0, 0, _resolution.w - 1, _resolution.h - 1, true);

draw_set_color(rgba2c(_brush.col, 255));
draw_rectangle(mouse_x-1, mouse_y-1, mouse_x-1, mouse_y-1, false);

draw_set_color(c_dkgray);
draw_rectangle(mouse_x-1, mouse_y-1, mouse_x-1, mouse_y-1, true);
draw_circle(_brush.wmx-1.5, _brush.wmy-1.5, _brush.size/2 - 1, true);
