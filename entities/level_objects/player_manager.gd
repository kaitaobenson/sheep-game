@icon("res://icons/container.svg")
class_name PlayerManager
extends Node2D

@export var player_scene: PackedScene

var players: Dictionary[int, Player] = {}

func _ready() -> void:
	await get_tree().process_frame  # Wait for level to ready
	var spawn_points: PlayerSpawnPoints = GameState.current_level_node.spawn_points
	
	# For debugging
	if GameState.player_datas.is_empty():
		spawn_player(0, 0, spawn_points.get_spawn_pos_for_player(0))
		spawn_player(1, 1, spawn_points.get_spawn_pos_for_player(1))
		return
	
	for p: GameState.PlayerData in GameState.player_datas:
		spawn_player(p.controller_id, p.skin_id, spawn_points.get_spawn_pos_for_player(p.controller_id))

var switch_player: bool = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("switch_player_debug"):
		if switch_player:
			players[0].controller_id = 1
			players[1].controller_id = 0
		else:
			players[0].controller_id = 0
			players[1].controller_id = 1
		
		switch_player = !switch_player

func spawn_player(controller_id: int, skin_id: int, pos: Vector2) -> void:
	if players.get(controller_id) != null:
		DebugLogger.error("Player with this controller id already exists!")
		return
	
	var player = player_scene.instantiate()
	
	player.controller_id = controller_id
	player.skin_id = skin_id
	player.global_position = pos
	
	players[controller_id] = player
	add_child(player)

func get_player(controller_id: int) -> Player:
	var player = players.get(controller_id)
	if player == null:
		DebugLogger.warn("Player not found for controller_id: %s" % controller_id)
	return player

func get_players() -> Array[Player]:
	return players.values()
