# Guhh??
extends Node2D

@export var player_scene: PackedScene

@onready var spawn_points: Array[Node2D] = [
	$"SpawnPoints/PlayerSpawn1",
	$"SpawnPoints/PlayerSpawn2",
	$"SpawnPoints/PlayerSpawn3",
	$"SpawnPoints/PlayerSpawn4",
]

func _ready() -> void:
	for i in range(Global.player_skin_ids.size()):
		var skin_id = Global.player_skin_ids[i]
		
		if skin_id != -1:
			var pos: Vector2 = spawn_points[i].global_position
			spawn_player(i, skin_id, pos)

func spawn_player(controller_id: int, skin_id: int, pos: Vector2) -> void:
	var player = player_scene.instantiate()
	
	player.controller_id = controller_id
	player.skin_id = skin_id
	player.global_position = pos
	
	add_child(player)
	
	
