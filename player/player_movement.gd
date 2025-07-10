class_name PlayerMovement
extends Node2D

@onready var player: Player = get_parent()
var controller_id: int = 0


@export var move_speed: float = 600.0

@export var jump_velocity: float = 900.0

@export var jump_buffer_time: float = 0.01
var jump_buffer_timer: float = 0.0

@export var jump_coyote_time: float = 0.2
var jump_coyote_timer: float = 0.0

@export var gravity: float = 2000.0

signal player_landed()

var is_running: bool = false
var is_jumping_up: bool = false
var is_falling_down: bool = false
var is_facing_right: bool = false

var was_on_floor: bool = false

# Returns
var new_player_velocity: Vector2 = Vector2.ZERO

func set_up() -> void:
	pass

func _physics_process(delta: float) -> void:
	## RUN ##
	
	# Input
	var right: float = Input.get_action_strength("walk_right_p" + str(controller_id))
	var left: float = Input.get_action_strength("walk_left_p" + str(controller_id))
	var move_dir: float = right - left
	
	new_player_velocity.x = (right - left) * move_speed
	
	# Flags
	is_running = abs(move_dir) > 0.0
	
	if move_dir > 0.0:
		is_facing_right = true
	if move_dir < 0.0:
		is_facing_right = false
	
	## JUMP ##
	
	# Jump buffer
	if Input.is_action_just_pressed("a_p" + str(controller_id)):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta
	
	if Input.is_action_just_released("a_p" + str(controller_id)):
		new_player_velocity.y *= 0.5
	
	# Coyote time
	if player.is_on_floor():
		jump_coyote_timer = jump_coyote_time
		is_falling_down = false
		new_player_velocity.y = 0.0
	else:
		jump_coyote_timer -= delta
		
		new_player_velocity.y += gravity * delta
		
		if new_player_velocity.y > 1:
			is_falling_down = true
			is_jumping_up = false
		else:
			is_falling_down = false
	
	# Check for jump
	if jump_buffer_timer > 0 && jump_coyote_timer > 0:
		new_player_velocity.y = -jump_velocity
		
		is_jumping_up = true
		jump_buffer_timer = 0
		jump_coyote_timer = 0
	
	# Emit landed signal
	if player.is_on_floor() && !was_on_floor:
		player_landed.emit()
	
	was_on_floor = player.is_on_floor()


func get_new_player_velocity() -> Vector2:
	return new_player_velocity
