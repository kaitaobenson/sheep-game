class_name Player
extends RigidBody2D
## Player of the game

var controller_id: int = 0  ## The controller device the player is using, also seen as player_id
var skin_id: int = 0  ## Player appearance / skin / character

var move_velocity: Vector2 = Vector2.ZERO  ## Player controlled movement

var facing_direction: int = 0  ## 1 is right, -1 is left
var is_grounded: bool = false  ## Is player grounded or in the air

var playing_animation: String = "":  ## Animation name
	get:
		return _player_animation.animation


# Player internal systems shouldn't be accessed from outside
# Sometimes internal systems can use variables from other internal systems
@onready var _player_animation: PlayerAnimation = $"PlayerAnimation"
@onready var _player_movement: PlayerMovement = $"PlayerMovement"
@onready var _player_grab_system: PlayerGrabSystem = $"PlayerGrabSystem"

@onready var grabbable_component: GrabbableComponent = $"PlayerGrabSystem/GrabbableComponent"


func _ready() -> void:
	pass


# Function not called when freeze == true
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if grabbable_component.is_being_thrown:
		move_velocity = Vector2.ZERO
		return
	
	if grabbable_component.is_being_grabbed:
		move_velocity = Vector2.ZERO
		global_position = grabbable_component.grabbed_by.global_position + Vector2(0, -96)
		return
	
	move_velocity = _player_movement.get_new_player_velocity()
	state.linear_velocity = move_velocity



func get_grabbable_component() -> GrabbableComponent:
	return grabbable_component

func set_freeze(on: bool) -> void:
	if on:
		gravity_scale = 0.0
	else:
		gravity_scale = 1.0
