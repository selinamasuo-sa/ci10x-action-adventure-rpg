#derived from Godot platform tutorial with assistance from Google Gemini
class_name PushableObject extends RigidBody2D

#var direction : Vector2 = Vector2.ZERO : set = _set_push

#intended to play a pushing sfx when being pushed (will work on in sprint 4?)
@onready var aud : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var pushing : AudioStream = preload("res://Assets/assetsViaYousef/push_stone.wav")
var pending_teleport: bool = false
var teleport_pos: Vector2 = Vector2.ZERO

func teleport_to(target_pos: Vector2):
	teleport_pos = target_pos
	pending_teleport = true

# This function is called by the physics engine, not the regular frame
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if pending_teleport:
		# Directly overwrite the physics state's transform origin
		state.transform.origin = teleport_pos
		
		# Reset all movement so it doesn't 'launch' from the new spot
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0
		
		# Clear the flag
		pending_teleport = false
		
		# Prevent visual ghosting in Godot 4
		reset_physics_interpolation()

'''func _set_push( vector_val : Vector2) -> void:
	direction = vector_val
	if direction == Vector2.ZERO:
		aud.stop()
	else:
		aud.play()
	pass # Replace with function body.
'''
