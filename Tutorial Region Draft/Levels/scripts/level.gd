#derived from GODOD tutorial (https://www.youtube.com/watch?v=rA-pI06mpw4) 4/26/26
#modified by Selinam Asuo 4/26/26

extends Node2D
class_name Level

func _ready() -> void:
	self.y_sort_enabled = true
	GlobalPlayerManagement.set_as_parent(self)
	GlobalLevelManagement.level_load_started.connect(Callable(self, "_free_level"))


func _free_level() -> void:
	GlobalPlayerManagement.unparent_player(self)
	queue_free()
