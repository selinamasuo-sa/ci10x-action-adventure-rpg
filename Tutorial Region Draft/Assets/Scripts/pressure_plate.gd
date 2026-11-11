#from GODOT Tutorial (https://www.youtube.com/watch?v=bA_XXOTdAOU&list=PLfcCiyd_V9GH8M9xd_QKlyU8jryGcy3Xa&index=233
#initally made on 4/6
#modified by Selinam Asuo 04/019
#edited by Selinam Asuo on 05/21/2026, added movable object detection feature to trigger the portal unlock

class_name pressurePlate extends Node2D

signal depressed
signal released

var bodies: int = 0
var player_bodies: int = 0
var object_bodies: int = 0
var active: bool = false
var rect_offset: Rect2

@export var obj_Reset: bool = false
@export var unlock_Plate: bool = false
@export var item_to_move: Node2D
@export var target_destination: Marker2D
@export var linked_portal: Portal

@onready var area_2d : Area2D = $Area2D
@onready var aud : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sprite : Sprite2D = $Sprite2D
@onready var aud_depressed : AudioStream = preload("res://Assets/assetsViaYousef/lever-01.wav")
@onready var aud_released : AudioStream = preload("res://Assets/assetsViaYousef/lever-02.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)
	area_2d.body_exited.connect(_on_body_exited)
	rect_offset  = sprite.region_rect
	

#adds/subtracts the number of entities on the pressure plate at a given time
func _on_body_entered(bod: Node2D) -> void:
	# allow player to trigger resets, but only pushable objects keep the portal unlocked
	if bod.is_in_group("Player") and obj_Reset == true:
		if target_destination != null and item_to_move != null:
			if item_to_move.has_method("teleport_to"):
				item_to_move.teleport_to(target_destination.global_position)

	if bod.is_in_group("Player"):
		player_bodies += 1
		check_state()
		return

	if not bod.is_in_group("PushableObject"):
		return

	bodies += 1
	object_bodies += 1
	check_state()
	
func _on_body_exited(bod: Node2D) -> void:
	if bod.is_in_group("Player"):
		player_bodies = max(player_bodies - 1, 0)
		check_state()
		return

	if not bod.is_in_group("PushableObject"):
		return

	bodies -= 1
	object_bodies = max(object_bodies - 1, 0)
	check_state()
	pass

#switches between the depressed (ON) and released (OFF) states of the pressure plate
func check_state() -> void:
	var should_be_active: bool = (bodies + player_bodies) > 0
	var should_unlock_portal: bool = (object_bodies + player_bodies) > 0

	if should_be_active and active == false:
		active = true
		sprite.region_rect.position.x = rect_offset.position.x - 32
		play_sfx(aud_depressed)
		depressed.emit()
	elif not should_be_active and active == true:
		active = false
		sprite.region_rect.position.x = rect_offset.position.x
		play_sfx(aud_released)
		released.emit()

	_set_linked_portal_locked(not should_unlock_portal)

func _set_linked_portal_locked(should_lock: bool) -> void:
	if linked_portal == null:
		return

	if linked_portal.locked == should_lock:
		return

	if linked_portal.has_method("toggle_lock"):
		linked_portal.toggle_lock()

func play_sfx(_stream: AudioStream) -> void:
	aud.stream = _stream
	aud.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
