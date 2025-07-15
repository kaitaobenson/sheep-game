@icon("res://icons/container.svg")
class_name PlayerSpawnPoints
extends Node2D

@onready var points: Array[Node2D] = [
	$"P1",
	$"P2",
	$"P3",
	$"P4",
]

func get_spawn_pos_for_player(id: int) -> Vector2:
	if id > 4 || id < 0:
		DebugLogger.error("Player id out of bounds")
		return Vector2.ZERO
	
	return points[id].global_position
