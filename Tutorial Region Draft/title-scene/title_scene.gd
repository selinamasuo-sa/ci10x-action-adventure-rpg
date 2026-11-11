#created by Selinam Asuo on 05/25/2026
extends Node2D

const START_LEVEL: String = "res://Levels/MainHub/main_hub_01.tscn"

@onready var button_start: Button = $CanvasLayer/Control/MainMenu/startButton
@onready var button_option: Button = $CanvasLayer/Control/MainMenu/optionButton
@onready var button_quit: Button = $CanvasLayer/Control/MainMenu/quitButton
@onready var main_menu: Control = $CanvasLayer/Control/MainMenu
@onready var options_screen: Control = $CanvasLayer/Control/OptionsScreen
@onready var button_options_back: Button = $CanvasLayer/Control/OptionsScreen/PanelContainer/VBoxContainer/backButton
@onready var brightness_slider: HSlider = $CanvasLayer/Control/OptionsScreen/PanelContainer/VBoxContainer/brightnessSlider
@onready var master_volume_slider: HSlider = $CanvasLayer/Control/OptionsScreen/PanelContainer/VBoxContainer/masterVolumeSlider
@onready var backdrop: Control = $CanvasLayer/Control/Backdrop
@onready var title_logo: Sprite2D = $CanvasLayer/Control/Backdrop/TitleLogo
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var music: AudioStream
@export var button_focus_aud: AudioStream
@export var button_press_aud: AudioStream
@export var master_volume_min_db: float = -40.0
@export var master_volume_max_db: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process_input(true)
	get_tree().paused = true
#	PauseMenu.process_node = Node.PROCESS_NODE_DISABLED
	GlobalPlayerManagement.player_spawned = false
	if GlobalPlayerManagement.player:
		GlobalPlayerManagement.player.visible = false

	setup_title_screen()
	GlobalLevelManagement.level_load_started.connect(exit_title_screen)
	pass


func _input(event: InputEvent) -> void:
	if options_screen == null or not options_screen.visible:
		return
	if event.is_action_pressed("Pause"):
		hide_options()
		get_viewport().set_input_as_handled()

func setup_title_screen() -> void:
	main_menu.visible = true
	options_screen.visible = false
	brightness_slider.min_value = GlobalVisualManagement.brightness_min
	brightness_slider.max_value = GlobalVisualManagement.brightness_max
	master_volume_slider.min_value = master_volume_min_db
	master_volume_slider.max_value = master_volume_max_db

	button_quit.pressed.connect(quit_game)
	button_start.pressed.connect(start_game)
	button_option.pressed.connect(show_options)
	button_options_back.pressed.connect(hide_options)
	brightness_slider.value_changed.connect(set_brightness)
	master_volume_slider.value_changed.connect(set_master_volume)
	button_start.grab_focus()

	brightness_slider.value = clampf(GlobalVisualManagement.brightness, GlobalVisualManagement.brightness_min, GlobalVisualManagement.brightness_max)
	master_volume_slider.value = clampf(0.0, master_volume_min_db, master_volume_max_db)
	set_brightness(brightness_slider.value)
	set_master_volume(master_volume_slider.value)

	button_start.focus_entered.connect(Callable(self, "play_audio").bind(button_focus_aud))
	button_option.focus_entered.connect(Callable(self, "play_audio").bind(button_focus_aud))
	button_options_back.focus_entered.connect(Callable(self, "play_audio").bind(button_focus_aud))
	brightness_slider.focus_entered.connect(Callable(self, "play_audio").bind(button_focus_aud))
	master_volume_slider.focus_entered.connect(Callable(self, "play_audio").bind(button_focus_aud))
	pass

func show_options() -> void:
	if options_screen == null:
		return
	play_audio(button_press_aud)
	main_menu.visible = false
	title_logo.visible = false
	options_screen.visible = true
	button_options_back.grab_focus()

func hide_options() -> void:
	if options_screen == null:
		return
	play_audio(button_press_aud)
	options_screen.visible = false
	title_logo.visible = true
	main_menu.visible = true
	button_option.grab_focus()

func set_brightness(value: float) -> void:
	if options_screen == null:
		return
	var clamped_value: float = clampf(value, GlobalVisualManagement.brightness_min, GlobalVisualManagement.brightness_max)
	backdrop.modulate = Color(clamped_value, clamped_value, clamped_value, 1.0)
	main_menu.modulate = Color(clamped_value, clamped_value, clamped_value, 1.0)
	options_screen.modulate = Color(clamped_value, clamped_value, clamped_value, 1.0)
	GlobalVisualManagement.set_brightness(clamped_value)

func set_master_volume(value: float) -> void:
	var clamped_value: float = clampf(value, master_volume_min_db, master_volume_max_db)
	var master_bus_index: int = AudioServer.get_bus_index("Master")
	if master_bus_index != -1:
		AudioServer.set_bus_volume_db(master_bus_index, clamped_value)

func start_game() ->  void:
	play_audio(button_press_aud)
	if GlobalPlayerManagement.player:
		GlobalPlayerManagement.player.direction = Vector2.ZERO
		GlobalPlayerManagement.player.cardinal_direction = Vector2.DOWN
		GlobalPlayerManagement.player.UpdateAnimation("Idle")
	GlobalLevelManagement.load_new_level(START_LEVEL, "", Vector2.ZERO)
	pass

func quit_game():
	get_tree().quit()
	pass

func exit_title_screen() -> void:
	GlobalPlayerManagement.player_spawned = false
	GlobalPlayerManagement.player.visible = true
#	PauseMenu.process_node = Node.PROCESS_NODE_ENABLED

	self.queue_free()
	pass

func play_audio(_a: AudioStream) -> void:
	audio_stream_player.stream = _a
	audio_stream_player.play()
	pass
