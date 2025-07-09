# util.gd
extends Node

func get_filenames_in_directory(path: String) -> Array[String]:
	var dir := DirAccess.open(path)
	if dir == null:
		printerr("Failed to open folder.")
	
	var files: Array[String] = []
	dir.list_dir_begin()
	var file_name := dir.get_next()
	
	while file_name != "":
		if not dir.current_is_dir():
			files.append(file_name)
		file_name = dir.get_next()
	
	dir.list_dir_end()
	
	return files
