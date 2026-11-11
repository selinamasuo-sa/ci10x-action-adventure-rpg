#created by Selinam Asuo on 05/27/2026
#with assistance from tutorial (https://www.youtube.com/watch?v=D57Q-8W9qNE)
extends CanvasLayer

const TITLE_SCENE_PATH: String = "res://title-scene/TitleScene.tscn"

@onready var menu_container: VBoxContainer = $Control/VBoxContainer
@onready var pause_label: Label = $Control/optionsLabel
@onready var button_resume: Button = $Control/VBoxContainer/resumeButton
@onready var button_option: Button = $Control/VBoxContainer/optionButton
@onready var button_quit_title: Button = $Control/VBoxContainer/toMainButton
@onready var options_screen: OptionsMenu = $Control/OptionsScreen

@export var master_volume_min_db: float = -40.0
@export var master_volume_max_db: float = 0.0

var is_paused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_pause_menu()
	button_resume.pressed.connect(resume_game)
	button_option.pressed.connect(show_options)
	button_quit_title.pressed.connect(to_title)
	options_screen.back_pressed.connect(hide_options)
	options_screen.brightness_changed.connect(set_brightness)
	options_screen.master_volume_changed.connect(set_master_volume)
	options_screen.configure(
		GlobalVisualManagement.brightness_min,
		GlobalVisualManagement.brightness_max,
		GlobalVisualManagement.brightness,
		master_volume_min_db,
		master_volume_max_db,
		0.0
	)

func _unhandled_input(event: InputEvent) -> void:
	var current_scene: Node = get_tree().current_scene
	if current_scene != null and current_scene.scene_file_path == TITLE_SCENE_PATH:
		return
	if event.is_action_pressed("Pause"):
		if options_screen.visible:
			hide_options()
			get_viewport().set_input_as_handled()
			return
		if is_paused == false:
			show_pause_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()

func show_pause_menu() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true
	pause_label.visible = true
	menu_container.visible = true
	options_screen.visible = false
	
	button_resume.grab_focus()
	
func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false
	pause_label.visible = false
	menu_container.visible = true
	options_screen.visible = false

func resume_game() -> void:
	if is_paused == false:
		return
	hide_pause_menu()
	
func to_title() -> void:
	if is_paused == false:
		return
	hide_pause_menu()
	GlobalLevelManagement.load_new_level(TITLE_SCENE_PATH, "", Vector2.ZERO)

func show_options() -> void:
	if is_paused == false:
		return
	menu_container.visible = false
	pause_label.visible = false
	options_screen.visible = true
	options_screen.button_back.grab_focus()


func hide_options() -> void:
	if is_paused == false:
		return
	options_screen.visible = false
	pause_label.visible = true
	menu_container.visible = true
	button_option.grab_focus()


func set_brightness(value: float) -> void:
	var clamped_value: float = clampf(value, GlobalVisualManagement.brightness_min, GlobalVisualManagement.brightness_max)
	GlobalVisualManagement.set_brightness(clamped_value)


func set_master_volume(value: float) -> void:
	var clamped_value: float = clampf(value, master_volume_min_db, master_volume_max_db)
	var master_bus_index: int = AudioServer.get_bus_index("Master")
	if master_bus_index != -1:
		AudioServer.set_bus_volume_db(master_bus_index, clamped_value)
