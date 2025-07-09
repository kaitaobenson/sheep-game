# player_skins.gd
extends Node

var skins: Array[Texture2D] = []

func _ready():
	var files: Array[String] = Util.get_filenames_in_directory("res://skins")
	files.sort()
	
	for file in files:
		var texture = load("res://skins/" + file)
		if texture is Texture2D:
			skins.append(texture)

func get_skin_amount() -> int:
	return skins.size()

func get_skin(id: int) -> Texture:
	if skins.is_empty():
		return null
	
	id = wrapi(id, 0, get_skin_amount())
	return skins[id]
