extends StaticBody2D

signal message_started
signal message_finished

@export var message_duration: float = 3.0

@onready var message_label: Label = $Message
@onready var arrow_sprite: Sprite2D = $Arrow
@onready var message_timer: Timer = $Message/TimeShown

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("NPC")
	message_label.hide()
	arrow_sprite.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func interact() -> void:
	message_started.emit()
	message_timer.start(message_duration)
	arrow_sprite.hide()
	message_label.show()

func _on_time_shown_timeout() -> void:
	message_label.hide()
	arrow_sprite.show()
	message_finished.emit()
	
