function make_inputs() {
	
	var c1 = merge_color(c_dkgray, c_white, 0.1);
	var c2 = merge_color(c_dkgray, c_white, 0.25);
	
	// COLOR PICKER
	input_create("3 numbers");
	input_set_max_chars("3 numbers", 3);
	input_set_bkg_color("3 numbers", c1);
	input_set_focused_bkg_color("3 numbers", c2);
	input_set_dimensions("3 numbers", 36, 24);
	input_set_text_padding("3 numbers", 2);
	
	input_copy("3 numbers", "cp_R");
	input_copy("3 numbers", "cp_G");
	input_copy("3 numbers", "cp_B");
	input_copy("3 numbers", "cp_A");
	input_copy("3 numbers", "cp_H");
	input_copy("3 numbers", "cp_S");
	input_copy("3 numbers", "cp_V");
	
	input_create("cp_HEX");
	input_set_max_chars("cp_HEX", 6);
	input_set_bkg_color("cp_HEX", c1);
	input_set_focused_bkg_color("cp_HEX", c2);
	input_set_dimensions("cp_HEX", 75, 24);
	input_set_text_padding("cp_HEX", 2);
	
	// LAYER NAME
	input_create("layer name");
	input_set_clamp_text_width("layer name", true);
	input_set_bkg_color("layer name", c1);
	input_set_focused_bkg_color("layer name", c2);
	input_set_dimensions("layer name", 110, 24);
	input_set_text_padding("layer name", 2);
}
