@icon("res://icons/character_select_panel.png")
class_name CharacterSelectPanel
extends Panel

@export var controller_id: int = 0

@onready var panel_manager: CharacterSelectPanelManager = $"../"
@onready var status_label: Label = $"Status"
@onready var skin_sprite: Sprite2D = $"Skin"

var current_skin_id: int = 0

var is_controller_connected: bool = false
var is_skin_selected: bool = false

func _ready() -> void:
	check_controllers()
	Input.joy_connection_changed.connect(recheck_controllers)

func check_controllers() -> void:
	var controller_ids = Input.get_connected_joypads()
	
	if controller_ids.has(controller_id):
		on_connected()
	else:
		on_disconnected()

func recheck_controllers(device: int, connected: bool) -> void:
	if device == controller_id:
		if connected:
			on_connected()
		else:
			on_disconnected()


func _process(_delta: float) -> void:
	if !is_controller_connected:
		return
	
	if !is_skin_selected:
		
		if MultiGamepadInput.is_action_just_pressed("ui_left", controller_id):
			current_skin_id -= 1
			skin_sprite.texture = PlayerSkins.get_skin(current_skin_id)
		
		if MultiGamepadInput.is_action_just_pressed("ui_right", controller_id):
			current_skin_id += 1
			skin_sprite.texture = PlayerSkins.get_skin(current_skin_id)
		
		if MultiGamepadInput.is_action_just_pressed("select", controller_id):
			if panel_manager.select_skin_for_player(current_skin_id, controller_id):
				on_skin_selected()
			else:
				flash_error()  # Can't select same skin
	else:
		if MultiGamepadInput.is_action_just_pressed("back", controller_id):
			on_connected()
			panel_manager.deselect_skin_for_player(controller_id)

func on_disconnected() -> void:
	modulate.a = 0.5
	status_label.text = "Not Connected"
	is_controller_connected = false
	is_skin_selected = false
	current_skin_id = 0

func on_connected() -> void:
	modulate.a = 1.0
	status_label.text = "Press A to Select Character"
	is_controller_connected = true
	is_skin_selected = false
	current_skin_id = 0

func on_skin_selected() -> void:
	modulate.a = 1.0
	status_label.text = "Ready"
	is_controller_connected = true
	is_skin_selected = true

func flash_error():
	modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	modulate = Color.WHITE
