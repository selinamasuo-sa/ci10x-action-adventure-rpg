# From Godot Enemy Tutorial 4/7/2026
# https://www.youtube.com/watch?v=1_BYHdyMYps&t=5s
# Modified by Armaan Rukhsar: 4/14/26, 4/21/26

extends CharacterBody2D

@export var speed = 0
var player_position
var target_position
@onready var player = get_parent().get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player_position = player.position
	target_position = (player_position - position).normalized()
	
	if position.distance_to(player_position) > 40:
		if player.health > 0:
			velocity = target_position * speed
			move_and_slide()
	elif $AttackCooldown.is_stopped() and player.health > 0:
		$Label.show()
		player.health = player.health - 10
		$AttackCooldown.start()
	

func _on_attack_cooldown_timeout() -> void:
	$Label.hide()
