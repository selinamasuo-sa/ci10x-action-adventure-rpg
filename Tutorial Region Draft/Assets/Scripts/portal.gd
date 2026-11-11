#Derived from Godot Tutorial (https://www.youtube.com/watch?v=YT5ZE0a4YtU)
#w/ assistance from Microsoft Copilot 4/5/26
#edited by Selinam Asuo on 05/07/2026, with inspiration from level_transition.gd
#modified by Selinam Asuo on 05/23/2026, adjusted sfx triggering so that the sound effects actually play when entering an unlocked portal
@tool
#borrows all of the assets from level transitions under the custom Portal denotation
class_name Portal extends LevelTransition

#2 additional adjustable variables indicating if a portal is a one way portal or is locked behind a task
@export var one_way: bool = false
@export var locked: bool = false
#sets up audio effect for quick teleportation
@onready var teleport_success : AudioStream = preload("res://interactables/portal/quick-teleport.wav")
#portal is active by default
var active = true
#allows portal animation to be accessed within portal code
@onready var portal_sprite = $animPortal

func _ready() -> void:
	super._ready()
	collision_mask = collision_mask | 16
	# ensure we only play SFX for actual player-triggered, open portals
	if locked:
		portal_sprite.play("closed")
	
	GlobalLevelManagement.level_loaded.connect(_on_level_loaded)
	
	if GlobalLevelManagement.target_transition == name and GlobalLevelManagement.just_teleported:
		active = false
		if portal_sprite:
			portal_sprite.play("closed")
			portal_sprite.frame = portal_sprite.sprite_frames.get_frame_count("closed") + 1
			
func _player_entered(body: Node2D) -> void:
	if not active or locked:
		return
	# require the entering body be the player
	if not body.is_in_group("Player"):
		return
	# require the portal to be visually open
	if portal_sprite and portal_sprite.animation != "open":
		return
	# play SFX immediately before starting the transition
	play_sfx(teleport_success)
	active = false
	if portal_sprite:
		portal_sprite.play("closed")
	await get_tree().create_timer(0.15).timeout
	
	super._player_entered(body)

# (removed level_load_started handling; sound plays when player enters an open, unlocked portal)

func _on_level_loaded() -> void:
	if GlobalLevelManagement.target_transition == name and GlobalLevelManagement.just_teleported:
		active = true
		if portal_sprite:
			portal_sprite.play("open")
			
	GlobalLevelManagement.just_teleported = false

#toggles the portal lock on & off
func toggle_lock():
	locked = !locked
	if locked == true:
		portal_sprite.play("closed")
	else:
		portal_sprite.play("open")
		
func play_sfx(_stream: AudioStream) -> void:
	var sfx_player := AudioStreamPlayer.new()
	sfx_player.stream = _stream
	sfx_player.bus = "Master"
	sfx_player.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().root.add_child(sfx_player)
	sfx_player.finished.connect(sfx_player.queue_free)
	sfx_player.play()
	
func _update_visuals() -> void:
	if portal_sprite == null:
		return
	
	portal_sprite.rotation_degrees = 0
	portal_sprite.flip_h = false
	portal_sprite.flip_v = false
	
	match side:
		SIDE.TOP:
			portal_sprite.flip_h = true
			portal_sprite.rotation_degrees = 90
		SIDE.BOTTOM:
			portal_sprite.flip_h = false
			portal_sprite.rotation_degrees = 90
		SIDE.LEFT:
			portal_sprite.flip_h = true
			portal_sprite.rotation_degrees = 0
		SIDE.RIGHT:
			portal_sprite.flip_h = false
			portal_sprite.rotation_degrees = 0
