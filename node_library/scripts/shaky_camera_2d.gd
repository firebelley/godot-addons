tool
extends Camera2D

const VISUALIZER_NAME = "ShakyCamera2DNoiseVisualizer"

export(OpenSimplexNoise) var shake_noise
export(float) var max_shake_offset = 20
export(float) var shake_decay = 5
export(float) var shake_frequency = 50;
export(bool) var visualize setget set_visualize, get_visualize;

var current_noise_value: float = 0
var current_shake_percentage = 0;
var current_direction_rotation = 0


func _ready():
	if shake_noise == null:
		shake_noise = OpenSimplexNoise.new()
		shake_noise.seed = randi()
		shake_noise.octaves = 3
		shake_noise.period = 2
		shake_noise.persistence = .414
		shake_noise.lacunarity = 2
	
	update_visualizer()


func _process(delta):
	if current_shake_percentage > 0:
		current_noise_value = wrapf(current_noise_value + (shake_frequency * delta), 0, 1000)
		var noise_x = shake_noise.get_noise_2d(current_noise_value, 0)
		var noise_y = shake_noise.get_noise_2d(0, current_noise_value)
		
		var offset_x = noise_x * max_shake_offset
		var offset_y = noise_y * max_shake_offset

		offset = Vector2(offset_x, offset_y) * current_shake_percentage * current_shake_percentage

	current_shake_percentage = max(current_shake_percentage - (shake_decay * delta), 0)


func shake(percent: float = 1.0):
	current_shake_percentage = percent;


func update_visualizer():
	var existing = get_node_or_null(VISUALIZER_NAME)
	if is_instance_valid(existing):
		existing.queue_free()
	
	if visualize && Engine.editor_hint:
		var sprite = Sprite.new()
		var noise_texture = NoiseTexture.new()
		noise_texture.noise = shake_noise
		
		self.add_child(sprite)
		sprite.texture = noise_texture
		sprite.owner = get_tree().edited_scene_root
		sprite.name = VISUALIZER_NAME


func set_visualize(val: bool):
	visualize = val
	update_visualizer()


func get_visualize():
	return visualize
