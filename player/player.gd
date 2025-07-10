class_name Player
extends CharacterBody2D

### READ ONLY ###
var controller_id: int = 0
var skin_id: int = 0

@onready var player_animation: PlayerAnimation = $"PlayerAnimation"
@onready var player_movement: PlayerMovement = $"PlayerMovement"

func _ready() -> void:
	player_movement.controller_id = self.controller_id
	player_movement.set_up()
	
	player_animation.skin_id = self.skin_id
	player_animation.set_up()
	
	#skin.texture = PlayerSkins.get_skin(skin_id)

func _physics_process(delta: float) -> void:
	velocity = player_movement.get_new_player_velocity()
	move_and_slide()
