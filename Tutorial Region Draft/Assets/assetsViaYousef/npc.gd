extends StaticBody2D

var timeShown = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Message.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("Interact"):
		$Arrow.hide()
		$Message.show()
		$Message/TimeShown.start(3)

func _on_time_shown_timeout() -> void:
	$Message.hide()
	$Arrow.show()
	
