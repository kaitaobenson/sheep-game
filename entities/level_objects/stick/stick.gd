class_name Stick
extends RigidBody2D

@onready var raycast: RayCast2D = $"RayCast2D"
@onready var grabbable_component: GrabbableComponent = $"GrabbableComponent"

@onready var gravity_vector: Vector2 = Util.get_gravity_vector()

var velocity: Vector2 = Vector2.ZERO

var stuck_in_ground: bool = false

func _ready() -> void:
	grabbable_component.grabbed.connect(_grabbed)

func _process(delta: float) -> void:
	if grabbable_component.is_being_grabbed:
		global_position = grabbable_component.get_grab_position()
		return
	
	if !stuck_in_ground:
		velocity += gravity_vector * delta
		velocity *= 0.99 * delta * 60
		position += velocity * delta
	
	rotation = velocity.angle()
	
	if raycast.is_colliding():
		stuck_in_ground = true

func _grabbed() -> void:
	stuck_in_ground = false

func get_grabbable_component() -> GrabbableComponent:
	return grabbable_component
