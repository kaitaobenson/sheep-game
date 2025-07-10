class_name PlayerAnimation
extends AnimatedSprite2D

@onready var player: Player = get_parent()
var skin_id: int


func set_up() -> void:
	player.player_movement.player_landed.connect(_on_player_landed)

func _process(delta: float) -> void:
	if player.player_movement.is_facing_right:
		scale.x = 3
	else:
		scale.x = -3
	
	if player.player_movement.is_jumping_up:
		if animation != "jump_up":
			play("jump_up")
		return
	
	if player.player_movement.is_falling_down:
		if animation != "jump_down":
			play("jump_down")
		return
	
	if player.player_movement.is_running:
		if animation != "run":
			play("run")
		return
	
	if animation == "jump_land":
		return
	
	play("idle")

func _on_player_landed() -> void:
	play("jump_land")
