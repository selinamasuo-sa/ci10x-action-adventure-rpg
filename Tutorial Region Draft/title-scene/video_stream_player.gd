#created by Selinam Asuo on 05/25/2026
extends VideoStreamPlayer

@export var fade_duration: float = 2
const loopThreshold = 0.06

func _ready():
	play()
	modulate.a = 1.0
	
	

func _process(_delta):
	if is_playing():
		var length = get_stream_length()
		var currentPos = get_stream_position()
		if length > 0  and (length - currentPos) <= fade_duration:
			var tween = create_tween()
			tween.tween_property(self, "modulate:a", 0.0, fade_duration)\
				.set_trans(Tween.TRANS_SINE)\
				.set_ease(Tween.EASE_OUT)
