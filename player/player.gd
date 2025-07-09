class_name Player
extends CharacterBody2D

### READ ONLY ###
var controller_id: int = 0
var skin_id: int = 0

@export var move_speed: float = 600.0
@export var jump_velocity: float = 800.0
@export var gravity: float = 2000.0

@onready var skin: Sprite2D = $"Skin"

"""
func _init(controller_id: int, skin_id: int) -> void:
	self.controller_id = controller_id
	self.skin_id = skin_id
"""

func _ready() -> void:
	print(skin_id)
	skin.texture = PlayerSkins.get_skin(skin_id)

func _physics_process(delta: float) -> void:
	var left: float = Input.get_action_strength("walk_left_p" + str(controller_id))
	var right: float = Input.get_action_strength("walk_right_p" + str(controller_id))
	
	velocity.x = (right - left) * move_speed
	
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0
		
		# Jump
		if Input.is_action_just_pressed("a_p" + str(controller_id)):
			velocity.y = -jump_velocity
	
	move_and_slide()
