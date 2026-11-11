#created by Selinam Asuo on 05/24/2026
extends VideoStreamPlayer

@export var fade_duration: float = 1.5 
const loopThreshold = 0.06 

func _ready():
	play()
	
	modulate.a = 0.0
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, fade_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

func _process(_delta):
	if is_playing():
		var length = get_stream_length()
		var currentPos = get_stream_position()
		
		# Force a restart just before the video fully plays
		if length > 0 and (length - currentPos) <= loopThreshold:
			# Resetting position to the beginning (0.0) for more seamless loop
			set_stream_position(0.0) 
