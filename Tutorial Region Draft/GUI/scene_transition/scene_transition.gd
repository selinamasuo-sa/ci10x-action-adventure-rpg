#derived from GODOT tutorial (https://www.youtube.com/watch?v=rA-pI06mpw4) 4/26/26
#modified by Selinam Asuo 4/26/26

extends CanvasLayer

@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer

func fade_out() -> bool:
	animation_player.play("fade_out")
	await animation_player.animation_finished
	return true
	
func fade_in() -> bool:
	animation_player.play("fade_in")
	await animation_player.animation_finished
	return true
