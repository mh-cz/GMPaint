function make_inputs() {
	
	var c1 = merge_color(c_dkgray, c_white, 0.1);
	var c2 = merge_color(c_dkgray, c_white, 0.2);
	
	// COLOR PICKER
	input_create("3 numbers");
	input_set_max_chars("3 numbers", 3);
	input_set_bkg_color("3 numbers", c1);
	input_set_focused_bkg_color("3 numbers", c2);
	input_set_dimensions("3 numbers", 36, 24);
	input_set_text_padding("3 numbers", 2);
	input_set_font("3 numbers", font_open_sans_11);
	
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
	input_set_font("cp_HEX", font_open_sans_11);
	
	// LAYER NAME
	input_create("layer name");
	input_set_clamp_text_width("layer name", true);
	input_set_bkg_color("layer name", c1);
	input_set_focused_bkg_color("layer name", c2);
	input_set_dimensions("layer name", 110, 24);
	input_set_text_padding("layer name", 4);
	input_set_font("layer name", font_open_sans_9);
	
	// TOOL OPTIONS
	input_create("4 numbers");
	input_set_max_chars("4 numbers", 4);
	input_set_bkg_color("4 numbers", c1);
	input_set_focused_bkg_color("4 numbers", c2);
	input_set_dimensions("4 numbers", 46, 24);
	input_set_text_padding("4 numbers", 2);
	input_set_font("4 numbers", font_open_sans_11);
	
	input_copy("4 numbers", "brush size");
	input_copy("4 numbers", "brush falloff");
	input_copy("4 numbers", "brush spacing");
	input_copy("4 numbers", "brush weight");
	input_copy("4 numbers", "line tension");
	input_copy("4 numbers", "fill tolerancy");
	
	// PAPER RESOLUTION
	input_copy("4 numbers", "paper w");
	input_copy("4 numbers", "paper h");
	input_set_text("paper w", _paper_res.w);
	input_set_text("paper h", _paper_res.h);
}
