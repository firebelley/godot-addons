@tool
extends AudioStreamPlayer
class_name RandomAudioStreamPlayer

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
	play_random_exclude_streams()


func play_random_exclude_streams(exclude_streams: Array[AudioStream] = []) -> RandomAudioStreamPlayer:
	var adjusted_streams = streams
	if exclude_streams.size() > 0:
		adjusted_streams = adjusted_streams.filter(func(audio_stream: AudioStream): return !exclude_streams.has(audio_stream))

	if adjusted_streams.size() == 0:
		return null
	
	var random_index = rng.randi_range(0, adjusted_streams.size() - 1)
	var stream = adjusted_streams[random_index]

	var instance = duplicate() as RandomAudioStreamPlayer
	instance.stream = stream
	if randomize_pitch:
		instance.pitch_scale = rng.randf_range(pitch_minimum, pitch_maximum)
	
	add_child(instance)
	instance.finished.connect(on_audio_finished.bind(instance))
	instance.play()
	return instance


func play_times(times: int):
	var played_streams: Array[AudioStream] = []
	for i in range(times):
		var audio_instance = play_random_exclude_streams(played_streams)
		if audio_instance != null:
			played_streams.append(audio_instance.stream)


func on_audio_finished(stream_player: RandomAudioStreamPlayer):
	stream_player.queue_free()
