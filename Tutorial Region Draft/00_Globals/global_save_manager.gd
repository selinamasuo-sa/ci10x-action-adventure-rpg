extends Node

const SAVE_PATH = "user://"

'''
signal game_loaded
signal game_saved
'''

var current_save : Dictionary = {
	"scene_path": "",
	"player": {
		"hp": 1,
		"max_hp": 1,
		"pos_x": 0,
		"pos_y": 0
	},
	"items": Array(),
	"persistence": Array(),
	"quests": Array()
}

func save_game() -> void:
	pass

func load_game() -> void:
	pass
