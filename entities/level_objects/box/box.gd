class_name Box
extends RigidBody2D

signal grabbed()
signal thrown()

const HITBOX_SIZE: Vector2 = Vector2(96, 96)

var just_thrown_time: float = 1.0
var just_thrown_timer: float = 0.0

var is_being_carried: bool = false
var is_being_thrown: bool = false

var stack_object_below: Node2D

var throw_velocity: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	just_thrown_timer = max(0.0, just_thrown_timer - delta)
	
	if is_being_thrown:
		custom_integrator = true
		throw_velocity = diminish_throw_velocity(throw_velocity, delta)
	elif is_being_carried:
		global_position = stack_object_below.global_position + Vector2(0, -HITBOX_SIZE.y)
		custom_integrator = true
	else:
		custom_integrator = false


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if is_being_thrown:
		if throw_velocity.is_equal_approx(Vector2.ZERO):
			is_being_thrown = false
		state.linear_velocity = throw_velocity


func is_grabbable() -> bool:
	return true

func get_carried_by(obj: Node2D) -> void:
	freeze = true
	rotation = 0.0
	lock_rotation = true
	
	is_being_carried = true
	
	stack_object_below = obj
	
	grabbed.emit()

func get_thrown(force: Vector2) -> void:
	print(force)
	freeze = false
	lock_rotation = false
	
	is_being_carried = false
	
	is_being_thrown = true
	
	stack_object_below = null
	throw_velocity = force
	
	just_thrown_timer = just_thrown_time
	
	thrown.emit()

func diminish_throw_velocity(velocity: Vector2, delta: float) -> Vector2:
	velocity.x *= 0.98
	velocity.y += 2000 * delta
	
	if just_thrown_timer > 0:
		return velocity
	
	if get_colliding_bodies().size() > 0:
		velocity.x = 0
		velocity.y = 0
	
	return velocity
