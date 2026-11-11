extends Node
class_name PlayerStateMachine

var states :  Array[ State ]
var prev_state :  State
var current_state : State



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var _next: State = null
	if current_state:
		_next = current_state.call("Process", delta)
	ChangeState(_next)
	pass


func _physics_process(delta):
	var _next: State = null
	if current_state:
		_next = current_state.call("Physics", delta)
	ChangeState(_next)
	pass


func _unhandled_input(event):
	var _next: State = null
	if current_state:
		_next = current_state.call("HandleInput", event)
	ChangeState(_next)
	pass




func ChangeState( new_state : State ) -> void:
	if new_state == null || new_state == current_state:
		return
	
	if current_state:
		current_state.Exit()

	prev_state = current_state
	current_state = new_state
	current_state.Enter()
