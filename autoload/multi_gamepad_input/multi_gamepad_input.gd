# multi_gamepad_input.gd
extends Node

signal action_pressed(action_name: String, device: int)
signal action_released(action_name: String, device: int)

@export var _actions: Array[MultiGamepadAction]
@export var _stick_deadzone: float

var _is_pressed_map: Dictionary[String, bool]
var _axis_map: Dictionary[String, float]
var _just_pressed_array: Array[String]
var _just_released_array: Array[String]

var _checked: bool = false

func _process(_delta: float) -> void:
	if _checked:
		_just_pressed_array = []
		_just_released_array = []

func _input(event: InputEvent) -> void:
	for action in _actions:
		if !action.is_this_key(event):
			continue
			
		_checked = false
		
		var pair: ActionControllerPair = ActionControllerPair.new(action.name, event.device)
		var string: String = pair.string()
		
		if !_is_pressed_map.has(action.name):
			_is_pressed_map[string] = false
		
		if event.is_pressed() && !_is_pressed_map[string]:
			action_pressed.emit(action.name, event.device)
			_is_pressed_map[string] = true
			_just_pressed_array.append(string)
		if event.is_released() && _is_pressed_map[string]:
			action_released.emit(action.name, event.device)
			_is_pressed_map[string] = false
			_just_released_array.append(string)
		
		if event is InputEventJoypadMotion:
			# Scale between the deadzone and one, so that the deadzone is zero 
			# but one is still one.
			var calib: float = (abs(event.axis_value) - _stick_deadzone) * (1.0 / (1.0 - _stick_deadzone))
			_axis_map[string] = max(0, calib)
		else:
			_axis_map[string] = 1.0 if event.is_pressed() else 0.0

## Returns whether an action is held down.
func is_action_pressed(action: String, device: int) -> bool:
	var pair: ActionControllerPair = ActionControllerPair.new(action, device)
	if _is_pressed_map.has(pair.string()):
		return _is_pressed_map[pair.string()]
	return false

## Gets the axis for the stick/button for this action.
func get_axis_value(action: String, device: int) -> float:
	var pair: ActionControllerPair = ActionControllerPair.new(action, device)
	if _axis_map.has(pair.string()):
		return _axis_map[pair.string()]
	return 0.0

## Check if an action is just pressed.
func is_action_just_pressed(action: String, device: int) -> bool:
	_checked = true
	return ActionControllerPair.new(action, device).string() in _just_pressed_array

## Check if an action was just released.
func is_action_just_released(action: String, device: int) -> bool:
	_checked = true
	return ActionControllerPair.new(action, device).string() in _just_released_array
