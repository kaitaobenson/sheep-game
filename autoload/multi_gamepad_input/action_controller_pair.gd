class_name ActionControllerPair
extends Resource

@export var action: String
@export var device: int

func _init(_action: String, _device: int) -> void:
	action = _action
	device = _device

func string() -> String:
	return action + str(device)
