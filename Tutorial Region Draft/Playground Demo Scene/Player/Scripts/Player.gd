class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine : Node = $StateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Interact.hide()
	state_machine.Initialize(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	direction.x = Input.get_action_strength('right') - Input.get_action_strength('left')
	direction.y = Input.get_action_strength('down') - Input.get_action_strength('up')
	
	if Input.is_action_pressed("Interact"):
		$Interact.hide()
		await get_tree().create_timer(3).timeout
		$Interact.show()
	pass
	
	
func _physics_process( _delta ):
		if move_and_slide():
			resolve_collisions()

func SetDirection() -> bool:
	var new_dir : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
		
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true


func UpdateAnimation(state : String) -> void:
	animation_player.play( state + "_" + AnimDirection() )
	pass

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func resolve_collisions() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var body := collision.get_collider() as RigidBody2D
		if body:
			body.apply_force(-2000 * collision.get_normal())


func _on_area_2d_body_entered(body: StaticBody2D) -> void:
	$Interact.show()

func _on_area_2d_body_exited(body: StaticBody2D) -> void:
	$Interact.hide()
