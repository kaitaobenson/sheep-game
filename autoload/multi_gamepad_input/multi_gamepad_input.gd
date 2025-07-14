# multi_gamepad_input.gd
extends Node

signal action_pressed(action_name: String, device: int)
signal action_released(action_name: String, device: int)

@export var _actions: Array[MultiGamepadAction]

var _is_pressed_map: Dictionary[String, bool]

func _input(event: InputEvent) -> void:
	for action in _actions:
		if !action.is_this_key(event):
			continue
		
		if !_is_pressed_map.has(action.name):
			_is_pressed_map[action.name] = false
		
		if event.is_pressed() && !_is_pressed_map[action.name]:
			action_pressed.emit(action.name, event.device)
			_is_pressed_map[action.name] = true
		if event.is_released() && _is_pressed_map[action.name]:
			action_released.emit(action.name, event.device)
			_is_pressed_map[action.name] = false

## Returns whether an action is held down.
func is_action_pressed(action: String) -> bool:
	if _is_pressed_map.has(action):
		return _is_pressed_map[action]
	return false

## Gets the axis for the stick/button for this action.
func get_axis_value(action: String) -> float:
	for item in _actions:
		if item.name == action:
			return item.axis
	return 0.0
