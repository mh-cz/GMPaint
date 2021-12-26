switch(_tool_current) {
	case _tools.brush: tool_brush(); break;
	case _tools.line: tool_line(); break;
	case _tools.fill: tool_fill(); break;
}

//switch(_tool_current) {
	//case _tools.brush: options_brush(); break;
	//case _tools.line: options_line(); break;
	//case _tools.fill: options_fill(); break;
//}


if keyboard_check_pressed(ord("R")) game_restart();

