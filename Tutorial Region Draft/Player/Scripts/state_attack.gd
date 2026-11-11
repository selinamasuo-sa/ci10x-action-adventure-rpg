class_name State_Attack extends State

var attacking : bool = false

@export var attack_sound : AudioStream

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_anim : AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"
@onready var attack: State_Attack = $"."
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"

@onready var idle: State_Idle = $"../Idle"
@onready var walk : State = $"../Walk"
@onready var hurt_box : HurtBox = $"../../Interactions/HurtBox"

#What happens when the player enters this State?
func Enter() -> void:
	player.UpdateAnimation('Attack')
	attack_anim.play("Attack_" + player.AnimDirection())
	animation_player.animation_finished.connect(EndAttack)
	
	audio.stream = attack_sound
	
	audio.play()
	attacking = true
	hurt_box.add_to_group("PlayerAttack")
	_update_hurt_box( 0.0 )

	# enable hurtbox immediately so the full swing arc can register
	hurt_box.set_deferred("monitoring", true)
	pass


#What happens when the player exits this State?
func Exit() -> void:
	animation_player.animation_finished.disconnect(EndAttack)
	attacking = false
	hurt_box.position = Vector2.ZERO
	hurt_box.rotation_degrees = 0
	hurt_box.set_deferred("monitoring", false)
	hurt_box.remove_from_group("PlayerAttack")
	pass


#What happens during the _process update in this State?e
func Process( _delta : float ) -> State:
	player.velocity = Vector2.ZERO
	if attacking:
		_update_hurt_box()
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk 
	return null

#What happens during the _physics_process update in this State?e
func Physics( _delta : float) -> State:
	return null

#What happens with input events in this State?
func HandleInput( _event: InputEvent ) -> State:
	return null

func EndAttack( _newAnimName : String ) -> void:
	attacking = false

func _update_hurt_box( progress : float = -1.0 ) -> void:
	if hurt_box == null:
		return

	var anim_length := maxf( animation_player.current_animation_length, 0.001 )
	var t := progress
	if t < 0.0:
		t = clampf( animation_player.current_animation_position / anim_length, 0.0, 1.0 )

	hurt_box.rotation_degrees = 0
	var swing_position := Vector2.ZERO
	match player.cardinal_direction:
		Vector2.RIGHT:
			swing_position = Vector2( lerpf( 32.0, 18.0, t ), 0.0 )
			hurt_box.rotation_degrees = 90
		Vector2.LEFT:
			swing_position = Vector2( lerpf( -32.0, -18.0, t ), 0.0 )
			hurt_box.rotation_degrees = 90
		Vector2.UP:
			swing_position = Vector2( 0.0, lerpf( -32.0, -18.0, t ) )
		Vector2.DOWN:
			swing_position = Vector2( 0.0, lerpf( 32.0, 18.0, t ) )
		_:
			swing_position = Vector2( lerpf( 32.0, 18.0, t ), 0.0 )
			hurt_box.rotation_degrees = 90

	hurt_box.position = swing_position
