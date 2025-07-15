class_name GrabbableComponent
extends Node2D

signal thrown()
signal grabbed()

signal stolen()

var is_being_grabbed: bool = false
var is_being_thrown: bool = false

var _just_thrown_timer: float = 0.0

var grabbed_by: Node2D = null

@onready var parent: RigidBody2D

func _ready() -> void:
	# KMS 
	if get_parent() is RigidBody2D:
		parent = get_parent()
	elif get_parent().get_parent() is RigidBody2D:
		parent = get_parent().get_parent()
	
	parent.contact_monitor = true
	parent.max_contacts_reported = 1


func _physics_process(delta: float) -> void:
	if is_being_thrown:
		
		_just_thrown_timer = min(_just_thrown_timer + delta, 0.4)
		
		if _just_thrown_timer > 0.6 && parent.get_colliding_bodies().size() > 0:
			
			_just_thrown_timer = 0.0
			is_being_thrown = false


func get_grabbed_by(obj: Node2D) -> void:
	# Object was grabbed by different person
	if is_being_grabbed && obj != grabbed_by:
		stolen.emit()
	
	is_being_grabbed = true
	grabbed_by = obj
	
	if parent.has_method("set_freeze"):
		parent.set_freeze(true)
	grabbed.emit()

func get_thrown(force: Vector2) -> void:
	is_being_grabbed = false
	is_being_thrown = true
	grabbed_by = null
	
	if parent.has_method("set_freeze"):
		parent.set_freeze(false)
	
	parent.linear_velocity = Vector2.ZERO
	parent.angular_velocity = 0.0
	parent.apply_central_impulse(force)
	thrown.emit()
