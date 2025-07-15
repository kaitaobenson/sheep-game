class_name MultiGamepadAction 
extends Resource

@export var name: String
@export var keyboard: InputEventKey
@export var joypad: InputEventJoypadButton
@export var joypad_nintendo: InputEventJoypadButton
@export var stick: InputEventJoypadMotion
@export var mouse: InputEventMouseButton

func is_this_key(event: InputEvent) -> bool:
	if event is InputEventKey && keyboard:
		return event.keycode == keyboard.keycode
	if event is InputEventJoypadButton && joypad:
		var controller_name: String = Input.get_joy_name(event.device)
		if controller_name == "Nintendo Switch Pro Controller":
			return event.button_index == joypad_nintendo.button_index
		else:
			return event.button_index == joypad.button_index
	if event is InputEventJoypadMotion && stick:
		return event.axis == stick.axis && \
			   sign(event.axis_value) == sign(stick.axis_value)
	if event is InputEventMouseButton && mouse:
		return event.button_index == mouse.button_index
	
	return false
