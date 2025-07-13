class_name Player
extends RigidBody2D
## Player of the game
## bluh bluh bluh

enum StackStatus {
	CARRIED,  ## being carried by another
	CARRIER_BASE,  ## at the bottom of a stack
	UNSTACKED,  ## not in any stack
}

const hitbox_size: Vector2 = Vector2(92.5, 96.0) ## Used in carry code.  About 3 x 3

var controller_id: int = 0  ## The controller device the player is using, also seen as player_id
var skin_id: int = 0  ## Player appearance / skin / character

var velocity: Vector2 = Vector2.ZERO  ## Used in _integrate_forces()

var facing_direction: int = 0  ## 1 is right, -1 is left
var is_grounded: bool = false  ## Is player grounded or in the air

var playing_animation: String = "":  ## Animation name
	get:
		return _player_animation.animation

# Grab + throw mechanic
var stack_status: StackStatus = StackStatus.UNSTACKED

var stack_object_above: Node2D  ## The player/object I’m carrying
var stack_object_below: Node2D  ## The player/object carrying me


# Player internal systems shouldn't be accessed from outside
# Sometimes internal systems can use variables from other internal systems
@onready var _player_animation: PlayerAnimation = $"PlayerAnimation"
@onready var _player_movement: PlayerMovement = $"PlayerMovement"
@onready var _player_grab_system: PlayerGrabSystem = $"PlayerGrabSystem"


func _ready() -> void:
	pass
	#skin.texture = PlayerSkins.get_skin(skin_id)

func _physics_process(delta: float) -> void:
	match stack_status:
		StackStatus.CARRIED:
			FREEZE_MODE_STATIC
			freeze = true
			global_position = stack_object_below.global_position + Vector2(0, -hitbox_size.y)
		
		StackStatus.CARRIER_BASE:
			velocity = _player_movement.get_new_player_velocity()

		StackStatus.UNSTACKED:
			velocity = _player_movement.get_new_player_velocity()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.linear_velocity = velocity


# Grab + throw 

func is_grabbable() -> bool:
	return true

func get_carried(by: Node2D) -> void:
	stack_status = StackStatus.CARRIED
	stack_object_below = by

func get_thrown() -> void:
	pass
