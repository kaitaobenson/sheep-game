@icon("res://icons/container.svg")
class_name PlayerGrabSystem
extends Node2D


@export var throw_force: float = 600

# Input
var controller_id: int = 0:
	get:
		return player.controller_id

@onready var player: Player = get_parent()

@onready var grabber_component: GrabberComponent = $"GrabberComponent"
@onready var grabbable_component: GrabbableComponent = $"GrabbableComponent"

@onready var raycasts: Array[RayCast2D] = [
	$"RayCast1",
	$"RayCast2",
	$"RayCast3",
]


func _physics_process(delta: float) -> void:
	scale.x = player.facing_direction
	
	if MultiGamepadInput.is_action_just_pressed("pickup/throw", player.controller_id):
		if !grabber_component.is_grabbing:
			var obj = raycast_for_objects()
			
			if obj != null:
				grabber_component.grab(obj)
				DebugLogger.info("Player %d grabbed object: %s" % [controller_id, obj])
		
		else:
			var force: Vector2 = Vector2.from_angle(deg_to_rad(-30)) * throw_force
			if abs(player.move_velocity.x) > 300:
				force.x += 20
			
			force.x *= player.facing_direction
			
			DebugLogger.info("Player %d threw object: %s" % [controller_id, grabber_component.grabbed_obj])
			grabber_component.throw(force)


func raycast_for_objects() -> Node2D:
	for ray in raycasts:
		if !ray.is_colliding():
			continue
		var collider = ray.get_collider()
		if collider.has_method("get_grabbable_component"):
			return collider
	
	return null
