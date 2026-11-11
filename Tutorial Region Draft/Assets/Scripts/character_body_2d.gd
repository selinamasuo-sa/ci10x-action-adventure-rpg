extends CharacterBody2D

@export var speed = 200

#maps basic user input with WASD and/or arrow keys
func getUserInput():
	var userInputDirection = Input.get_vector("left", "right", "up", "down")
	velocity = userInputDirection * speed
	
func _physics_process(_delta):
	getUserInput()
	move_and_slide()

func _on_portal_to_dungeon_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.set_position($startOfDungeon.global_position) #test for portal collision


func _on_portal_to_dungeon_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("Player"):
		body.set_position($startOfDungeon.global_position) #test for portal collision
