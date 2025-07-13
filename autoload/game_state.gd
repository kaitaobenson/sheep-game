# game_state.gd
extends Node

var player_datas: Array[PlayerData] = []

var current_level_node: Level

func register_player(controller_id: int, skin_id: int) -> void:
	var p = PlayerData.new()
	p.controller_id = controller_id
	p.skin_id = skin_id
	player_datas.append(p)

class PlayerData:
	var controller_id: int
	var skin_id: int
