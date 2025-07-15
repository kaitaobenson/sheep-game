@icon("res://icons/box.svg")
class_name Box
extends RigidBody2D

@onready var grabbable_component: GrabbableComponent = $"GrabbableComponent"


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if grabbable_component.is_being_grabbed:
		global_position = grabbable_component.grabbed_by.global_position + Vector2(0, -96)


func get_grabbable_component() -> GrabbableComponent:
	return grabbable_component

func set_freeze(on: bool) -> void:
	if on:
		rotation = 0.0
		lock_rotation = true
		gravity_scale = 0.0
	else:
		lock_rotation = false
		gravity_scale = 1.0
