class_name CharacterSelectPanelManager
extends HBoxContainer

@export_file_path("*.tscn") var level1: String

@onready var start_label: Label = $"../Start"

var all_players_are_ready: bool = false

var player_count: int = 0
var player_skin_ids: Array[int] = [-1, -1, -1, -1]

func _ready() -> void:
	set_player_count(0, false)
	start_label.modulate.a = 0.0
	Input.joy_connection_changed.connect(set_player_count)

func set_player_count(_device: int, _connected: bool) -> void:
	var controller_ids = Input.get_connected_joypads()
	player_count = controller_ids.size()


# Returns false if skin is already taken
func select_skin_for_player(skin_id: int, player_id: int) -> bool:
	skin_id = wrapi(skin_id, 0, PlayerSkins.get_skin_amount())
	
	if player_skin_ids[player_id] == skin_id:
		return true
	
	if !player_skin_ids.has(skin_id):
		player_skin_ids[player_id] = skin_id
		check_for_readiness()
		return true
	
	return false

# Always returns true
func deselect_skin_for_player(player_id: int) -> bool:
	player_skin_ids[player_id] = -1
	check_for_readiness()
	return true

func check_for_readiness() -> void:
	var ready_players: int = 0
	
	for id in player_skin_ids:
		if id != -1:
			ready_players += 1
	
	if ready_players == player_count:
		all_players_are_ready = true
		start_label.modulate.a = 1.0
	else:
		all_players_are_ready = false
		start_label.modulate.a = 0.0

func _process(delta: float) -> void:
	# Only "host" controller can start the game.
	if all_players_are_ready && MultiGamepadInput.is_action_just_pressed("select", 0):
		register_players()
		get_tree().change_scene_to_file(level1)

func register_players() -> void:
	for i in range(player_skin_ids.size()):
		var id = player_skin_ids[i]
		if id == -1:
			continue
		
		GameState.register_player(i, id)
