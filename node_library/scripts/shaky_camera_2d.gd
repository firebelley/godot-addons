@tool
extends Camera2D

const VISUALIZER_NAME = "ShakyCamera2DNoiseVisualizer"

@export var shake_noise: FastNoiseLite
@export var max_shake_offset: float = 20
@export var shake_decay: float = 5
@export var shake_frequency: float = 50;
@export var visualize: bool : get = get_visualize, set = set_visualize;

var current_noise_value: float = 0
var current_shake_percentage = 0;
var current_direction_rotation = 0


func _ready():
	if shake_noise == null:
		shake_noise = FastNoiseLite.new()
		shake_noise.noise_type = FastNoiseLite.TYPE_PERLIN
		shake_noise.seed = randi()
		shake_noise.fractal_octaves = 3
		shake_noise.frequency = 2
	
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
	
	if visualize && Engine.is_editor_hint():
		var sprite = Sprite2D.new()
		var noise_texture = NoiseTexture2D.new()
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
