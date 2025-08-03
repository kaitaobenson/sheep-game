@icon("res://icons/sheep.png")
class_name Sheep
extends RigidBody2D

@onready var grabbable_component: GrabbableComponent = $"GrabbableComponent"
@onready var gravity_vector: Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector") * ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	$"AnimatedSprite2D".play("idle")

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if grabbable_component.is_being_grabbed:
		global_position = grabbable_component.get_grab_position()

func get_grabbable_component() -> GrabbableComponent:
	return grabbable_component

func set_freeze(on: bool) -> void:
	if on:
		gravity_scale = 0.0
	else:
		gravity_scale = 1.0
