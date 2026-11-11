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
	await get_tree().create_timer(.075).timeout
	hurt_box.monitoring = true
	pass


#What happens when the player exits this State?
func Exit() -> void:
	animation_player.animation_finished.disconnect(EndAttack)
	attacking = false
	hurt_box.monitoring = false
	pass


#What happens during the _process update in this State?e
func Process( _delta : float ) -> State:
	player.velocity = Vector2.ZERO
	
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
