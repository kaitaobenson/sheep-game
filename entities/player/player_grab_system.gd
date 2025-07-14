class_name PlayerGrabSystem
extends Node2D


@onready var raycasts: Array[RayCast2D] = [
	$"RayCast1",
	$"RayCast2",
	$"RayCast3",
]


@onready var player: Player = get_parent()

var just_thrown_time: float = 0.1
var just_thrown_timer: float = 0.0

func _ready() -> void:
	player.connect("thrown", just_thrown)
	#player.connect()

func _physics_process(delta: float) -> void:
	var controller_id: String = str(player.controller_id)
	
	scale.x = player.facing_direction
	
	if Input.is_action_just_pressed("x_p" + controller_id):
		if player.stack_object_above == null:
			var obj = raycast_for_objects()
			
			if obj == null:
				return
			
			player.carry(obj)
		else:
			var force = Vector2.from_angle(deg_to_rad(-30)) * 700
			force.x += abs(player.move_velocity.x * 0.5)
			force.x *= player.facing_direction
			
			player.throw(force)
	
	if just_thrown_timer > 0:
		just_thrown_timer -= delta

func diminish_throw_velocity(velocity: Vector2, delta: float) -> Vector2:
	if just_thrown_timer > 0:
		return velocity
	
	if player.is_grounded:
		velocity.x = 0
		velocity.y = 0
	else:
		velocity.x *= 0.98
		velocity.y += 2000 * delta
	
	return velocity


func raycast_for_objects() -> Node2D:
	for ray in raycasts:
		if !ray.is_colliding():
			continue
		var collider = ray.get_collider()
		if collider.has_method("is_grabbable") && collider.is_grabbable():
			return collider
	
	return null

"""
func get_stack_count_recursive(stack_object_above: Node2D, count: int = 0) -> int:
	if stack_object_above == null:
		return count
	
	count += 1
	
	if stack_object_above is Player:
		var player := stack_object_above as Player
		return get_stack_count_recursive(player.stack_object_above, count)
	else:
		return count
"""
func just_thrown() -> void:
	just_thrown_timer = just_thrown_time
