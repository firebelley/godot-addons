@tool
extends CanvasLayer

signal transitioned_halfway
signal transitioned_fully

@onready var animation_player = $AnimationPlayer


func _enter_tree():
	add_to_group(name)


func transition_to_scene(scene_path: String):
	transition()
	await self.transitioned_halfway
	get_tree().change_scene_to_file(scene_path)


func transition():
	if animation_player.is_playing():
		animation_player.stop(true)
	animation_player.play("transition")

func set_transition_texture(texture: Texture2D):
	get_node("TransitionRect").material.set_shader_parameter("transition_texture", texture)


func set_transition_color(color: Color):
	get_node("TransitionRect").material.set_shader_parameter("transition_color", color)


func set_speed_scale(scale: float):
	animation_player.playback_speed = scale


func emit_transitioned_halfway():
	emit_signal("transitioned_halfway")


func emit_transitioned_fully():
	emit_signal("transitioned_fully")
