function save_undo(surf) {
	
	var buf = buffer_create(surface_get_width(surf) * surface_get_height(surf) * 4, buffer_fixed, 1);
	buffer_seek(buf, buffer_seek_start, 0);
	buffer_get_surface(buf, surf, 0);
	buffer_save(buf, working_directory+"ur_"+_filename+"\\"+string(undo_counter++)+".u");
	buffer_delete(buf);
}
