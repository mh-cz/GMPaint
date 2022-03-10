function make_menus() {
	
	draw_set_font(font_open_sans_9);
	
	var buttons = ds_list_create();
	
	ds_list_add(buttons, { text: _langstr[$ _language].menu_new_file, on_click: function() {}});
	ds_list_add(buttons, { text: _langstr[$ _language].menu_open_file, on_click: function() { load(); }});
	ds_list_add(buttons, { text: _langstr[$ _language].menu_import_image, on_click: function() {}});
	ds_list_add(buttons, { text: _langstr[$ _language].menu_export_image, on_click: function() {}});
	ds_list_add(buttons, { text: _langstr[$ _language].menu_save, on_click: function() { save(); }});
	ds_list_add(buttons, { text: _langstr[$ _language].menu_save_as, on_click: function() { save_as(); }});
	
	var maxlen = 0;
	foreach "btn" in buttons as_list maxlen = max(string_width(btn.text)+16, maxlen);
	
	ds_list_add(_menu_list, { text: _langstr[$ _language].menu_file, w: string_width(_langstr[$ _language].menu_file)+10, b: buttons, bw: maxlen });
}

function draw_upper_menu() {
	
	draw_set_font(font_open_sans_9);
	
	var h = _upper_bar.h;
	var yy = 0;
	var xx = 8;
	var text_offx = 4;
	
	var g1 = merge_color(c_dkgray, c_gray, 0.15);
	var g2 = merge_color(c_dkgray, c_gray, 0.5);
	
	draw_set_valign(1);
	
	foreach "menu" in _menu_list as_list {
		
		draw_set_color(c_white);
		draw_text(xx + text_offx, h/2, menu.text);
		
		if point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), xx, 0, xx+menu.w, h) {
			_sel_menu_opt = menu.text
			_mouse_over_menu = true;
		}
		
		if _sel_menu_opt == menu.text {
			
			draw_set_color(c_black);
			draw_rectangle(xx, yy+h, xx+menu.bw, yy+h+(ds_list_size(menu.b))*h-1, true);
			
			foreach ["i", "btn"] in menu.b as_list {
			
				var r = [xx, yy + (i+1) * h, xx + menu.bw, yy + (i+1) * h + h - 1];
				
				if point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), r[0], r[1], r[2], r[3]) {
					_mouse_over_menu = true;
					draw_set_color(g1);
					if mouse_check_button_pressed(mb_left) {
						btn.on_click();
					}
				}
				else draw_set_color(g2);
			
				draw_rectangle(r[0], r[1], r[2], r[3], false);
			
				draw_set_color(c_white);
				draw_text(xx + text_offx, yy + (i+1) * h + h/2, btn.text);
			}
		
			xx += menu.w + 10;
		}
	}
	
	draw_set_valign(0);
	
	if !_mouse_over_menu _sel_menu_opt = "";
	else _mouse_over_gui = true;
}
