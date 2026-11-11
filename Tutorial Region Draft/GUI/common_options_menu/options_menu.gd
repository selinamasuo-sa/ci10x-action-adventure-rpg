class_name OptionsMenu extends Control

signal back_pressed
signal brightness_changed(value: float)
signal master_volume_changed(value: float)

@onready var button_back: Button = $PanelContainer/VBoxContainer/backButton
@onready var brightness_slider: HSlider = $PanelContainer/VBoxContainer/brightnessSlider
@onready var master_volume_slider: HSlider = $PanelContainer/VBoxContainer/masterVolumeSlider


func _ready() -> void:
	button_back.pressed.connect(_on_back_pressed)
	brightness_slider.value_changed.connect(_on_brightness_value_changed)
	master_volume_slider.value_changed.connect(_on_master_volume_value_changed)


func configure(
	brightness_min: float,
	brightness_max: float,
	brightness_value: float,
	master_volume_min: float,
	master_volume_max: float,
	master_volume_value: float
) -> void:
	brightness_slider.min_value = brightness_min
	brightness_slider.max_value = brightness_max
	master_volume_slider.min_value = master_volume_min
	master_volume_slider.max_value = master_volume_max
	brightness_slider.value = clampf(brightness_value, brightness_min, brightness_max)
	master_volume_slider.value = clampf(master_volume_value, master_volume_min, master_volume_max)


func _on_back_pressed() -> void:
	back_pressed.emit()


func _on_brightness_value_changed(value: float) -> void:
	brightness_changed.emit(value)


func _on_master_volume_value_changed(value: float) -> void:
	master_volume_changed.emit(value)