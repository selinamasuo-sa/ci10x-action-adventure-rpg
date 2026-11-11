#derived from GODOT tutorial (https://www.youtube.com/watch?v=rA-pI06mpw4) 4/26/26
#modified by Selinam Asuo 4/26/26

extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	if GlobalPlayerManagement.player_spawned == false:
		GlobalPlayerManagement.set_player_pos(global_position)
		GlobalPlayerManagement.player_spawned = true
