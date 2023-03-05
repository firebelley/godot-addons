@tool
extends AudioStreamPlayer2D

@export var streams: Array[AudioStream] = []
@export var randomize_pitch: bool = false
@export var pitch_minimum: float = .9
@export var pitch_maximum: float = 1.1
@export_category("Limit Simultaneous Plays")
## If greater than 0, limits the number of playing sounds to this number.
@export var max_playing: int = 0
## Every RandomAudioStreamPlayer2D with the same ID will count toward the max_playing count.
@export var max_playing_id: String = ""

var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()


func _get_configuration_warnings():
	var warnings: Array[String] = []
	if stream != null:
		warnings.append("The stream property has no effect on this node. Use the streams array to configure audio streams.")
	if pitch_scale != 1 && randomize_pitch:
		warnings.append("Randomized pitch scale will override the manually configured pitch scale.")
	if max_playing > 0 && (max_playing_id == "" || max_playing_id == null):
		warnings.append("max_playing is configured but no ID has been supplied. This may produce undesirable results.")
	return warnings


func get_max_playing_id():
	return "RandomAudioStreamPlayer2D_%s" % max_playing_id


func play_random():
	play_random_exclude_streams()


func play_random_exclude_streams(exclude_streams: Array[AudioStream] = []) -> AudioStreamPlayer2D:
	var adjusted_streams = streams
	if exclude_streams.size() > 0:
		adjusted_streams = adjusted_streams.filter(func(audio_stream: AudioStream): return !exclude_streams.has(audio_stream))

	if adjusted_streams.size() == 0:
		return null

	if max_playing > 0 && get_tree().get_nodes_in_group(get_max_playing_id()).size() >= max_playing:
		return null
	
	var random_index = rng.randi_range(0, adjusted_streams.size() - 1)
	var stream = adjusted_streams[random_index]

	var instance = AudioStreamPlayer2D.new()
	instance.stream = stream
	instance.volume_db = volume_db
	instance.pitch_scale = pitch_scale
	instance.max_polyphony = max_polyphony
	instance.bus = bus
	instance.attenuation = attenuation
	instance.area_mask = area_mask
	instance.max_distance = max_distance

	if max_playing > 0:
		instance.add_to_group(get_max_playing_id())

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


func on_audio_finished(stream_player: AudioStreamPlayer2D):
	stream_player.queue_free()
