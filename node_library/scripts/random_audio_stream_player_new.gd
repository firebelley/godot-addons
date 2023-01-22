@tool
extends AudioStreamPlayer
class_name RandomAudioStreamPlayerNew

@export var streams: Array[AudioStream] = []
@export var randomize_pitch: bool = false
@export var pitch_minimum: float = .9
@export var pitch_maximum: float = 1.1

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()


func _get_configuration_warnings():
	var warnings: Array[String] = []
	if stream != null:
		warnings.append("The stream property has no effect on this node. Use the streams array to configure audio streams.")
	if pitch_scale != 1 && randomize_pitch:
		warnings.append("Randomized pitch scale will override the manually configured pitch scale.")
	return warnings


func play_random(): 
	if streams.size() == 0:
		return
	
	var random_index = rng.randi_range(0, streams.size() - 1)
	var stream = streams[random_index]

	var instance = duplicate() as RandomAudioStreamPlayerNew
	instance.stream = stream
	if randomize_pitch:
		instance.pitch_scale = rng.randf_range(pitch_minimum, pitch_maximum)
	
	add_child(instance)
	instance.finished.connect(on_audio_finished.bind(instance))
	instance.play()


func play_times(times: int):
	for i in range(times):
		play_random()


func on_audio_finished(stream_player: RandomAudioStreamPlayerNew):
	stream_player.queue_free()
