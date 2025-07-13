@abstract
class_name Level
extends Node2D

@export var spawn_points: PlayerSpawnPoints
@export var player_manager: PlayerManager
@export var level_camera: LevelCamera

func _ready() -> void:
	GameState.current_level_node = self
