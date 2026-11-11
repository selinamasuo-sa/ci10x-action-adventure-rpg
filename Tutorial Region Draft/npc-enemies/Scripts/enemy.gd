class_name Enemy extends CharacterBody2D

signal direction_changed( new_direction : Vector2 )
signal enemy_damaged( hurt_box : HurtBox )
signal enemy_destroyed( hurt_box : HurtBox )

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

const MIN_HP := 2
const DEFAULT_HP := 3
const MAX_HP := 100
const MIN_SCALE := 0.85
const DEFAULT_SCALE := 1.0
const MAX_SCALE := 3.0

@export var use_random_hp: bool = false
@export var counts_for_room_clear: bool = false
@export_range(MIN_HP, MAX_HP, 1)
var hp: int = 3

@export_range(MIN_HP, MAX_HP, 1)
var random_hp_min: int = 3

@export_range(MIN_HP, MAX_HP, 1)
var random_hp_max: int = 8

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player : Player
var invunerable : bool = false
var base_scale : Vector2 = Vector2.ONE
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var hit_box : HitBox = $HitBox
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Enemy")
	base_scale = scale
	_apply_initial_hp()
	_update_scale_from_hp()
	state_machine.initialize( self )
	player = GlobalPlayerManagement.player
	hit_box.damaged.connect( _take_damage )
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func  _physics_process(_delta: float) -> void:
	move_and_slide()
	

func set_direction( _new_direction : Vector2 ) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int( round( 
		(direction + cardinal_direction * .1).angle()
		/ TAU * DIR_4.size()))
	
	var new_dir = DIR_4 [ direction_id ]
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	direction_changed.emit( new_dir )
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true

func update_animation( state : String) -> void:
	animation_player.play( state + "_" + anim_direction() )
	pass

func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func _take_damage( hurt_box : HurtBox ) -> void:
	if invunerable == true:
		return
	hp -= hurt_box.damage
	hp = maxi( hp, 0 )
	_update_scale_from_hp()
	if hp > 0:
		enemy_damaged.emit( hurt_box )
	else:
		enemy_destroyed.emit( hurt_box )

func _apply_initial_hp() -> void:
	if use_random_hp == false:
		hp = clampi( hp, MIN_HP, MAX_HP )
		return

	rng.randomize()
	var min_hp := clampi( random_hp_min, MIN_HP, MAX_HP )
	var max_hp := clampi( random_hp_max, MIN_HP, MAX_HP )
	if min_hp > max_hp:
		var temp_hp := min_hp
		min_hp = max_hp
		max_hp = temp_hp
	hp = rng.randi_range( min_hp, max_hp )

func _update_scale_from_hp() -> void:
	var clamped_hp := clampi( hp, MIN_HP, MAX_HP )
	var scale_factor := DEFAULT_SCALE
	if clamped_hp <= DEFAULT_HP:
		var lower_t := inverse_lerp( float( MIN_HP ), float( DEFAULT_HP ), float( clamped_hp ) )
		scale_factor = lerpf( MIN_SCALE, DEFAULT_SCALE, lower_t )
	else:
		var upper_t := inverse_lerp( float( DEFAULT_HP ), float( MAX_HP ), float( clamped_hp ) )
		scale_factor = lerpf( DEFAULT_SCALE, MAX_SCALE, upper_t )

	scale = base_scale * scale_factor
