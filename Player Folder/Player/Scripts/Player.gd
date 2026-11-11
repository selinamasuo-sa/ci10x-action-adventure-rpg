# From Micheal Games 
# https://www.youtube.com/watch?v=QPeycNt29tY&list=PLfcCiyd_V9GH8M9xd_QKlyU8jryGcy3Xa
# Modified by Armaan Rukhsar: 4/14/26, 4/21/26
# modified by Selinam Asuo: 05/29/2026, added feature for setting the health in the editor and added option for randomized health customization between a defined min and max value.

class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine : Node = $StateMachine
@onready var health : int = 100

signal DirectionChanged(new_direction : Vector2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Player")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	direction.x = Input.get_action_strength('right') - Input.get_action_strength('left')
	direction.y = Input.get_action_strength('down') - Input.get_action_strength('up')
	
	if health <= 0:
		process_mode = PROCESS_MODE_DISABLED
	
	if Input.is_action_pressed("Interact"):
		$Interact.hide()
		await get_tree().create_timer(3).timeout
		$Interact.show()
	
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
	DirectionChanged.emit(new_dir)
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
