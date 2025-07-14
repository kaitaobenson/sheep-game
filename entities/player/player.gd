class_name Player
extends RigidBody2D
## Player of the game

signal grabbed()
signal thrown()

const HITBOX_SIZE: Vector2 = Vector2(92.5, 96.0) ## Used in carry code.  About 3 x 3

var controller_id: int = 0  ## The controller device the player is using, also seen as player_id
var skin_id: int = 0  ## Player appearance / skin / character

var move_velocity: Vector2 = Vector2.ZERO  ## Player controlled movement
var throw_velocity: Vector2 = Vector2.ZERO  ## Grab and throw movement

var facing_direction: int = 0  ## 1 is right, -1 is left
var is_grounded: bool = false  ## Is player grounded or in the air

var playing_animation: String = "":  ## Animation name
	get:
		return _player_animation.animation

# Grab + throw mechanic
var is_being_carried: bool = false
var is_being_thrown: bool = false

var stack_object_above: Node2D  ## The player/object I’m carrying
var stack_object_below: Node2D  ## The player/object carrying me


# Player internal systems shouldn't be accessed from outside
# Sometimes internal systems can use variables from other internal systems
@onready var _player_animation: PlayerAnimation = $"PlayerAnimation"
@onready var _player_movement: PlayerMovement = $"PlayerMovement"
@onready var _player_grab_system: PlayerGrabSystem = $"PlayerGrabSystem"


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if is_being_carried:
		global_position = stack_object_below.global_position + Vector2(0, -HITBOX_SIZE.y)
		move_velocity = Vector2.ZERO
		
	elif is_being_thrown:
		move_velocity = Vector2.ZERO
		throw_velocity = _player_grab_system.diminish_throw_velocity(throw_velocity, delta)
		
	else:
		move_velocity = _player_movement.get_new_player_velocity()


# Function not called when freeze == true
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if is_being_thrown:
		if throw_velocity.is_equal_approx(Vector2.ZERO):
			is_being_thrown = false
		state.linear_velocity = throw_velocity
	
	else:
		state.linear_velocity = move_velocity


# Grab + throw 
func is_grabbable() -> bool:
	return true

func carry(obj: Node2D) -> void:
	stack_object_above = obj
	
	if !obj.has_method("get_carried_by"):
		DebugLogger.error("Invalid carry object, didn't have method 'get_carried_by'")
	
	obj.get_carried_by(self)
	
	if !obj.has_signal("grabbed"):
		DebugLogger.error("Invalid carry object, didn't have signal 'grabbed'")
	
	obj.grabbed.connect(stop_carrying)

func stop_carrying() -> void:
	stack_object_above = null

func get_carried_by(obj: Node2D) -> void:
	freeze = true
	is_being_carried = true
	
	stack_object_below = obj
	
	grabbed.emit()

func throw(force: Vector2) -> void:
	if stack_object_above:
		
		if !stack_object_above.has_method("get_thrown"):
			DebugLogger.error("Invalid carry object")
		
		stack_object_above.get_thrown(force)
		stack_object_above = null

func get_thrown(force: Vector2) -> void:
	freeze = false
	is_being_carried = false
	
	is_being_thrown = true
	
	stack_object_below = null
	throw_velocity = force
	
	thrown.emit()
