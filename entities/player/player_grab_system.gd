class_name PlayerGrabSystem
extends Node2D

signal grabbed_object(object: Node2D)

@onready var raycasts: Array[RayCast2D] = [
	$"RayCast1",
	$"RayCast2",
	$"RayCast3",
]

var stack_status: Player.StackStatus:
	get:
		return player.stack_status
	set(value):
		player.stack_status = value

## The player/object I’m carrying
var stack_object_above: Node2D:  
	get:
		return player.stack_object_above
	set(value):
		player.stack_object_above = value

## The player/object carrying me
var stack_object_below: Node2D:
	get:
		return player.stack_object_below
	set(value):
		player.stack_object_below = value


@onready var player: Player = get_parent()


func process_physics() -> void:
	var controller_id: String = str(player.controller_id)
	
	if Input.is_action_just_pressed("x_p" + controller_id):
		var obj = raycast_for_objects()
		
		if obj == null:
			return
	
	if stack_object_below:
		stack_status = Player.StackStatus.CARRIED
	if !stack_object_below && stack_object_above:
		stack_status = Player.StackStatus.CARRIER_BASE
	if !stack_object_below && !stack_object_above:
		stack_status = Player.StackStatus.UNSTACKED
	"""
	match stack_status:
		StackStatus.CARRIED:
			pass
		
		StackStatus.CARRIER_BASE:
			pass
		
		StackStatus.UNSTACKED:
			return
	"""

func raycast_for_objects() -> Node2D:
	for ray in raycasts:
		if !ray.is_colliding():
			return null
		if ray.has_method("is_grabbable") && ray.is_grabbable():
			return ray.get_collider()
	
	return null

func get_stack_count_recursive(stack_object_above: Node2D, count: int = 0) -> int:
	if stack_object_above == null:
		return count
	
	count += 1
	
	if stack_object_above is Player:
		var player := stack_object_above as Player
		return get_stack_count_recursive(player.stack_object_above, count)
	else:
		return count
