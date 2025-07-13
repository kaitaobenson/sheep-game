class_name PlayerMovement
extends Node2D


signal player_jumped()
signal player_landed()

# Speed / force / buffering options
@export var move_speed: float = 600.0
@export var gravity: float = 2000.0
@export var jump_velocity: float = 900.0

@export var jump_buffer_time: float = 0.01
var jump_buffer_timer: float = 0.0

@export var jump_coyote_time: float = 0.2
var jump_coyote_timer: float = 0.0

var just_jumped_time: float = 0.1
var just_jumped_timer: float = 0.0

# Flags
var is_running: bool = false
var is_jumping_up: bool = false
var is_falling_down: bool = false

var was_on_floor: bool = false

# Controller input
var controller_id: int = 0:
	get:
		return player.controller_id

# Output
var new_player_velocity: Vector2 = Vector2.ZERO

# Nodes
@onready var player: Player = get_parent()

@onready var raycasts: Array[RayCast2D] = [
	$"RayCast1",
	$"RayCast2",
	$"RayCast3",
	$"RayCast4",
]


# Custom function
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
		player.facing_direction = 1
	if move_dir < 0.0:
		player.facing_direction = -1
	
	## JUMP ##
	
	# Jump buffer
	if Input.is_action_just_pressed("a_p" + str(controller_id)):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta
	
	if Input.is_action_just_released("a_p" + str(controller_id)):
		new_player_velocity.y *= 0.5
	
	# Coyote time
	if is_on_floor():
		jump_coyote_timer = jump_coyote_time
		is_falling_down = false
		new_player_velocity.y = 0.0
		
		player.is_grounded = true
	else:
		jump_coyote_timer -= delta
		
		new_player_velocity.y += gravity * delta
		
		if new_player_velocity.y > 1:
			is_falling_down = true
			is_jumping_up = false
		else:
			is_falling_down = false
		
		player.is_grounded = false
	
	# Check for jump
	if jump_buffer_timer > 0 && jump_coyote_timer > 0:
		new_player_velocity.y = -jump_velocity
		
		just_jumped_timer = just_jumped_time
		
		is_jumping_up = true
		player_jumped.emit()
		
		jump_buffer_timer = 0
		jump_coyote_timer = 0
	else:
		just_jumped_timer -= delta
	
	# Emit landed signal
	if is_on_floor() && !was_on_floor:
		player_landed.emit()
	
	was_on_floor = is_on_floor()


func is_on_floor() -> bool:
	if just_jumped_timer > 0:
		return false
	
	for ray in raycasts:
		if ray.is_colliding():
			return true
	return false


func get_new_player_velocity() -> Vector2:
	return new_player_velocity
