# From Godot Enemy Tutorial 4/7/2026
# https://www.youtube.com/watch?v=1_BYHdyMYps&t=5s
#editted by Selinam Asuo 05/07/2026

extends CharacterBody2D

@export var speed = 65

func _physics_process(_delta: float) -> void:
	# Access the player directly from your Global manager
	var player = GlobalPlayerManagement.player
	
	# Check if the player has actually been spawned yet
	if player == null:
		return
		
	var player_position = player.global_position
	var target_position = (player_position - global_position).normalized()
	
	if global_position.distance_to(player_position) > 35:
		velocity = target_position * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
