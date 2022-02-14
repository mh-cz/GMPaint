function make_menus() {
	
	var buttons = ds_list_create();
	var ls = variable_struct_get(_langstr, _language);
	
	ds_list_add(buttons, { text: variable_struct_get(ls, "menu_new_file"), on_click: function() {}});
	ds_list_add(buttons, { text: variable_struct_get(ls, "menu_open_file"), on_click: function() {}});
	ds_list_add(buttons, { text: variable_struct_get(ls, "menu_import_file"), on_click: function() {}});
	
	ds_map_add(_menu_map, variable_struct_get(ls, "menu_file"), buttons);
	
}
