#derived from GODOT tutorial (https://www.youtube.com/watch?v=rA-pI06mpw4) 4/26/26
#modified by Selinam Asuo 4/26/26

extends Node

signal level_load_started
signal level_loaded
signal TileMapBoundsChanged(bounds: Array[Vector2])

var current_tilemap_bounds: Array[Vector2]
var target_transition: String
var pos_offset: Vector2

var just_teleported: bool = false # Flag to signal the new portal

func _ready() -> void:
	await get_tree().process_frame
	level_loaded.emit()
	
func change_tilemap_bounds(bounds: Array[Vector2]) -> void:
	current_tilemap_bounds = bounds
	# Debug: report bounds when they change
	TileMapBoundsChanged.emit(bounds)

func load_new_level(
	level_path: String,
	_target_transition: String,
	_pos_offset: Vector2
) -> void:
	get_tree().paused = true
	target_transition = _target_transition
	pos_offset = _pos_offset
	await SceneTransition.fade_out()
	
	level_load_started.emit()
	await get_tree().process_frame
	get_tree().change_scene_to_file(level_path)
	await get_tree().process_frame
	get_tree().paused = false
	
	await SceneTransition.fade_in()
	await get_tree().process_frame
	
	level_loaded.emit()
	pass
