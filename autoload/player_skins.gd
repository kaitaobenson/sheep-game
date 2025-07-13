# player_skins.gd
extends Node

# Btw its a bit weird but in order to get an export variable
# With an autoload, you need to make a scene
# With a node and the script attached to it, and autoload that scene
@export_dir var path_to_skins_folder: String

var skins: Array[Texture2D] = []

func _ready():
	var files: Array[String] = Util.get_filenames_in_directory(path_to_skins_folder)
	files.sort()
	
	for file in files:
		if !file.ends_with(".png"):
			continue
		
		var texture = load(path_to_skins_folder + "/" + file)
		if texture is Texture2D:
			skins.append(texture)

func get_skin_amount() -> int:
	return skins.size()

func get_skin(id: int) -> Texture:
	if skins.is_empty():
		return null
	
	id = wrapi(id, 0, get_skin_amount())
	return skins[id]
