function make_inputs() {
	input_create("3 numbers");
	input_set_max_chars("3 numbers", 3);
	input_set_bkg_color("3 numbers", c_gray);
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
	input_set_bkg_color("cp_HEX", c_gray);
	input_set_dimensions("cp_HEX", 75, 24);
	input_set_text_padding("cp_HEX", 2);
}
