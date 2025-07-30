@icon("res://entities/level_objects/carrot/carrot.png")
class_name Carrot
extends RigidBody2D

@onready var grabbable_component: GrabbableComponent = $"GrabbableComponent"

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if grabbable_component.is_being_grabbed:
		global_position = grabbable_component.get_grab_position()

func get_grabbable_component() -> GrabbableComponent:
	return grabbable_component

func set_freeze(on: bool) -> void:
	if on:
		lock_rotation = true
		gravity_scale = 0.0
	else:
		lock_rotation = false
		gravity_scale = 1.0
