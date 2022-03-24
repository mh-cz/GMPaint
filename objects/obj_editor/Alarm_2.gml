// LOAD

if load_from_file() {
	set_bottom_right_text("Loaded: \""+_fpath+_loaded_ext+"\"", 2);
	undo_save("draw");
}
