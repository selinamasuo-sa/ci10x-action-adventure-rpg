#derived from GODOT Tutorial (https://www.youtube.com/watch?v=KQ9XreEyn6U) 04/30/2026
#modified by Selinam Asuo 04/30/2026

extends TileMap
class_name LevelTileMap

@export var affects_camera_bounds: bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if affects_camera_bounds:
		GlobalLevelManagement.change_tilemap_bounds(GetTilemapBounds())
	pass # Replace with function body.


func GetTilemapBounds() -> Array[Vector2]:
	var bounds: Array[Vector2] = [Vector2.ZERO, Vector2.ZERO]
	bounds[0] = Vector2(get_used_rect().position * rendering_quadrant_size)
	bounds[1] = Vector2(get_used_rect().end * rendering_quadrant_size)
	return bounds
