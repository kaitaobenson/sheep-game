class_name LevelCamera
extends Node2D

const SCREEN_SIZE: Vector2 = Vector2(1152, 648)

const MIN_ZOOM: float = 0.3
const MAX_ZOOM: float = 1.2

const CAMERA_EDGE_PADDING: float = 300.0

@onready var cam: Camera2D = $Camera2D

@onready var min_x: float = $LeftCamBound.global_position.x + SCREEN_SIZE.x / 2
@onready var max_x: float = $RightCamBound.global_position.x - SCREEN_SIZE.x / 2
@onready var min_y: float = $TopCamBound.global_position.y + SCREEN_SIZE.y / 2
@onready var max_y: float = $BottomCamBound.global_position.y - SCREEN_SIZE.y / 2

func _physics_process(delta: float) -> void:
	var players := GameState.current_level_node.player_manager.get_players()
	if players.is_empty():
		return

	var player_positions: Array[Vector2] = []
	for player in players:
		player_positions.append(player.global_position)

	# Position
	var center: Vector2 = get_average_position(player_positions)
	center.x = clamp(center.x, min_x, max_x)
	center.y = clamp(center.y, min_y, max_y)
	cam.global_position = center

	# Zoom
	var min_pos: Vector2 = get_min_position(player_positions)
	var max_pos: Vector2 = get_max_position(player_positions)

	min_pos -= Vector2(CAMERA_EDGE_PADDING, CAMERA_EDGE_PADDING)
	max_pos += Vector2(CAMERA_EDGE_PADDING, CAMERA_EDGE_PADDING)

	var visible_area: Vector2 = max_pos - min_pos

	var zoom_x: float = SCREEN_SIZE.x / visible_area.x
	var zoom_y: float = SCREEN_SIZE.y / visible_area.y
	var final_zoom: float = clamp(min(zoom_x, zoom_y), MIN_ZOOM, MAX_ZOOM)

	cam.zoom = Vector2(final_zoom, final_zoom)



func get_average_position(positions: Array[Vector2]) -> Vector2:
	var total: Vector2 = Vector2.ZERO
	for pos in positions:
		total += pos
	return total / positions.size()


func get_min_position(positions: Array[Vector2]) -> Vector2:
	var result: Vector2 = positions[0]
	for pos in positions:
		result.x = min(result.x, pos.x)
		result.y = min(result.y, pos.y)
	return result


func get_max_position(positions: Array[Vector2]) -> Vector2:
	var result: Vector2 = positions[0]
	for pos in positions:
		result.x = max(result.x, pos.x)
		result.y = max(result.y, pos.y)
	return result
