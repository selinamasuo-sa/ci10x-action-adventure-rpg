#derived from GODOT tutorial (https://www.youtube.com/watch?v=rA-pI06mpw4) 4/26/26
#modified by Selinam Asuo 4/26/26

extends Node

const PLAYER = preload("res://Player/player.tscn")
var player : Player
var player_spawned : bool = false

func _ready() -> void:
	instantiate_player()

func instantiate_player() -> void:
	player = PLAYER.instantiate()
	add_child(player)
	pass

func set_player_pos(_new_pos: Vector2) -> void:
	player.global_position = _new_pos
	pass

func set_as_parent(_p: Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	_p.add_child(player)
	
func unparent_player(_p: Node2D) -> void:
	_p.remove_child(player)
