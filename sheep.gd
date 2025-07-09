class_name Sheep
extends RigidBody2D

func _physics_process(delta: float) -> void:
	$"AnimatedSprite2D".play("walk")
	linear_velocity.x = -100
	
