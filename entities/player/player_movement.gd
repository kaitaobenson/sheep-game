@icon("res://icons/player_movement.png")
class_name PlayerMovement
extends Node2D

# Signals
signal player_jumped()
signal player_landed()

# Movement settings
@export var move_speed: float = 600.0
@export var gravity: float = 2000.0
@export var jump_velocity: float = 900.0

# Timers
var jump_buffer_time: float = 0.01
var jump_coyote_time: float = 0.2
var just_jumped_time: float = 0.1
var just_thrown_time: float = 0.3

var jump_buffer_timer: float = 0.0
var jump_coyote_timer: float = 0.0
var just_jumped_timer: float = 0.0
var just_thrown_timer: float = 0.0

# Flags
var is_running: bool = false
var is_jumping_up: bool = false
var is_falling_down: bool = false
var was_on_floor: bool = false

# Input
var controller_id: int = 0:
	get:
		return player.controller_id

# Output
var new_player_velocity: Vector2 = Vector2.ZERO

# Nodes
@onready var player: Player = get_parent()
@onready var raycasts: Array[RayCast2D] = [
	$"RayCast1", $"RayCast2", $"RayCast3", $"RayCast4"
]


func _ready() -> void:
	await get_tree().process_frame
	player.grabbable_component.thrown.connect(on_just_thrown)


func _physics_process(delta: float) -> void:
	update_timers(delta)
	update_flags()
	handle_signals()

	if can_run():
		process_run(delta)

	if can_jump():
		process_jump()

	if can_do_gravity():
		process_gravity(delta)

func process_run(_delta: float) -> void:
	var right: float = MultiGamepadInput.get_axis_value("walk_right", controller_id)
	var left: float = MultiGamepadInput.get_axis_value("walk_left", controller_id)
	var move_dir: float = right - left

	new_player_velocity.x = move_dir * move_speed

	is_running = abs(move_dir) > 0.0

	if move_dir > 0.0:
		player.facing_direction = 1
	elif move_dir < 0.0:
		player.facing_direction = -1


func process_jump() -> void:
	if MultiGamepadInput.is_action_just_pressed("jump", controller_id):
		jump_buffer_timer = jump_buffer_time
	
	if MultiGamepadInput.is_action_just_released("jump", controller_id) && is_jumping_up:
		new_player_velocity.y *= 0.5

	if jump_buffer_timer > 0 && jump_coyote_timer > 0:
		new_player_velocity.y = -jump_velocity
		just_jumped_timer = just_jumped_time
		is_jumping_up = true
		player_jumped.emit()
		jump_buffer_timer = 0
		jump_coyote_timer = 0


func process_gravity(delta: float) -> void:
	if is_on_floor():
		new_player_velocity.y = 0
	else:
		new_player_velocity.y += gravity * delta


func update_timers(delta: float) -> void:
	jump_buffer_timer = max(0.0, jump_buffer_timer - delta)
	jump_coyote_timer = max(0.0, jump_coyote_timer - delta)
	just_jumped_timer = max(0.0, just_jumped_timer - delta)
	just_thrown_timer = max(0.0, just_thrown_timer - delta)


func update_flags() -> void:
	is_running = false
	is_jumping_up = new_player_velocity.y < -10.0
	is_falling_down = new_player_velocity.y > 10.0 && !is_on_floor()

	if is_on_floor():
		jump_coyote_timer = jump_coyote_time
		new_player_velocity.y = 0.0
		player.is_grounded = true
	else:
		player.is_grounded = false


func handle_signals() -> void:
	if is_on_floor() && !was_on_floor:
		player_landed.emit()
	was_on_floor = is_on_floor()

func on_just_thrown() -> void:
	just_thrown_timer = just_thrown_time


func can_run() -> bool:
	return !player.grabbable_component.is_being_grabbed && !player.grabbable_component.is_being_thrown

func can_jump() -> bool:
	return !player.grabbable_component.is_being_grabbed && !player.grabbable_component.is_being_thrown

func can_do_gravity() -> bool:
	return !player.grabbable_component.is_being_grabbed && !player.grabbable_component.is_being_thrown


func is_on_floor() -> bool:
	if just_jumped_timer > 0 || just_thrown_timer > 0:
		return false
	for ray in raycasts:
		if ray.is_colliding():
			return true
	return false


func get_new_player_velocity() -> Vector2:
	return new_player_velocity
