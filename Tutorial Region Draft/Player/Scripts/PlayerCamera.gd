#derived from GODOT tutorial (https://www.youtube.com/watch?v=KQ9XreEyn6U) 4/28/26
#modified by Selinam Asuo 4/28/26

class_name PlayerCamera extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalLevelManagement.TileMapBoundsChanged.connect(UpdateLimits)
	UpdateLimits(GlobalLevelManagement.current_tilemap_bounds)
	pass # Replace with function body.

func UpdateLimits(bounds:Array[Vector2]) -> void:
	if bounds == []:
		return
	limit_left = int(bounds[0].x)
	limit_top = int(bounds[0].y)
	limit_right = int(bounds[1].x)
	limit_bottom = int(bounds[1].y)
	pass
