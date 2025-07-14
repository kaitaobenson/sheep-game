class_name MultiGamepadAction extends Resource

@export var name: String
@export var keyboard: InputEventKey
@export var joypad: InputEventJoypadButton
@export var joypad_nintendo: InputEventJoypadButton
@export var stick: InputEventJoypadMotion
@export var mouse: InputEventMouseButton
@export var stick_deadzone: float

var axis: float = 0.0

func is_this_key(event: InputEvent) -> bool:
	var is_this: bool = false
	if event is InputEventKey && keyboard:
		is_this = event.keycode == keyboard.keycode
	if event is InputEventJoypadButton && joypad:
		var controller_name: String = Input.get_joy_name(event.device)
		if controller_name == "Nintendo Switch Pro Controller":
			is_this = event.button_index == joypad_nintendo.button_index
		else:
			is_this = event.button_index == joypad.button_index
	if event is InputEventJoypadMotion && stick:
		is_this = event.axis == stick.axis && \
			   sign(event.axis_value) == sign(stick.axis_value) && \
			   abs(event.axis_value) > stick_deadzone
	if event is InputEventMouseButton && mouse:
		is_this = event.button_index == mouse.button_index
	
	if is_this:
		axis = event.is_pressed() if !event is InputEventJoypadMotion else event.axis_value
		return true
	else:
		return false
