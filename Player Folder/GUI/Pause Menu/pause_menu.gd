extends CanvasLayer

@onready var button_save: Button = $VBoxContainer/ButtonSave
@onready var button_load: Button = $VBoxContainer/ButtonLoad

var is_paused : bool = false

func _ready() -> void:
	hide_pause_menu()
	button_save.pressed.connect( on_save_pressed )
	button_load.pressed.connect( on_load_pressed )

	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		if is_paused == false:
			show_pause_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()
		

func show_pause_menu() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true
	button_save.grab_focus()

func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false


func on_save_pressed() -> void:
	if is_paused == false:
		return
	SaveManager.save_game()
	hide_pause_menu()
	pass
	
	
func on_load_pressed() -> void:
	if is_paused == false:
		return
	SaveManager.load_game()
	hide_pause_menu()
	pass
