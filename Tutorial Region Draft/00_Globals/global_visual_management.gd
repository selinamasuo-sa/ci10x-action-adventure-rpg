extends CanvasModulate

@export var brightness_min: float = 0.25
@export var brightness_max: float = 1.0

var brightness: float = 1.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	apply_brightness_to_current_scene()


func set_brightness(value: float) -> void:
	brightness = clampf(value, brightness_min, brightness_max)
	apply_brightness_to_current_scene()


func apply_brightness_to_current_scene() -> void:
	color = Color(brightness, brightness, brightness, 1.0)