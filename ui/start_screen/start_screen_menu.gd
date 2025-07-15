@icon("res://icons/start_screen_menu.png")
class_name StartScreenMenu
extends VBoxContainer

@export_file_path("*.tscn") var character_select_screen

@onready var play_button: Button = $"PlayButton"
@onready var settings_button: Button = $"SettingsButton"
@onready var exit_button: Button = $"ExitButton"

func _ready() -> void:
	play_button.grab_focus()
	
	Input.get_connected_joypads()
	
	play_button.pressed.connect(_on_play_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)

func _on_play_button_pressed() -> void:
	#TODO: change to async loading n stuff
	get_tree().change_scene_to_file(character_select_screen)

func _on_settings_button_pressed() -> void:
	print("settings")
	pass

func _on_exit_button_pressed() -> void:
	print("exit")
	pass
