#Code by Michael Games on Youtube, https://www.youtube.com/watch?v=D57Q-8W9qNE&t=1563s
#Edited by Youssef Saleh


extends Node

const SAVE_PATH = "user://"


signal game_loaded
signal game_saved


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
	var file := FileAccess.open( SAVE_PATH + "save.sav", FileAccess.WRITE)
	var save_json = JSON.stringify( current_save )
	
	
	
pass

func load_game() -> void:
	pass
