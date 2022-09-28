tool
extends Node

export(Array, AudioStream) var streams = [] setget set_streams, get_streams
export(bool) var randomize_pitch = false
export(float, 0, 10, .05) var pitch_minimum = .9
export(float, 0, 10, .05) var pitch_maximum = 1.1

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()


func _get_configuration_warning():
	if streams == null && get_child_count() > 0:
		return "Stream array is out of sync with children. Children should be configured only through the streams property of %s." % name
	if get_child_count() != streams.size():
		return "Stream array is out of sync with children. Children should be configured only through the streams property of %s." % name
	for i in range(get_child_count()):
		var child = get_child(i)
		if child.stream != streams[i]:
			return "Node {child_name} is out of sync with the streams array of {root_name}.".format({ "child_name": child.name, "root_name": name })
	return ""


func play(): 
	var valid_children = []
	for child in get_children():
		if !child.playing:
			valid_children.append(child)
	
	if valid_children.size() == 0:
		return
	
	var random_index = rng.randi_range(0, valid_children.size() - 1)
	var child = valid_children[random_index] as AudioStreamPlayer
	if randomize_pitch:
		child.pitch_scale = rng.randf_range(pitch_minimum, pitch_maximum)
	child.play()
	

func play_times(times: int):
	for i in range(times):
		play()


func remove_stream_player(node: AudioStreamPlayer):
	node.owner = null
	remove_child(node)
	node.queue_free()


func add_new_node(stream: AudioStream):
	var root = get_tree().edited_scene_root
	var new_node = AudioStreamPlayer.new()
	add_child(new_node)
	new_node.owner = root
	new_node.stream = stream


func update_stream_player_nodes():
	if !Engine.editor_hint:
		return

	var existing_nodes = []
	for node in get_children():
		if (node.stream != null):
			existing_nodes.append(node)
		remove_child(node)
		node.owner = null

	for i in range(streams.size()):
		var root = get_tree().edited_scene_root
		if (streams[i] != null):
			var existing_node = extract_first_node_with_stream(existing_nodes, streams[i].resource_path)
			if existing_node != null:
				add_child(existing_node)
				existing_node.owner = root
				existing_node.name = "AudioStreamPlayer%s" % (existing_node.get_index() + 1)
			else:
				add_new_node(streams[i])
		else:
			add_new_node(null)

	for node in existing_nodes:
		node.queue_free()


func extract_first_node_with_stream(existing_nodes: Array, resource_path: String) -> AudioStreamPlayer:
	var found_node: AudioStreamPlayer = null
	for i in range(existing_nodes.size()):
		var node = existing_nodes[i]
		if (node.stream != null && node.stream.resource_path == resource_path):
			found_node = node
			existing_nodes.remove(i)
			break
	return found_node


func set_streams(num):
	streams = num
	update_stream_player_nodes()


func get_streams():
	return streams
