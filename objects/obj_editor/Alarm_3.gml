// SAVE AS

save_settings(_fpath, _filename);
save_all_layers(_fpath);

set_bottom_right_text("Saved as: "+_fpath, 2);

_filename = old[0];
_fpath = old[1];
