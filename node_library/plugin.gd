tool
extends EditorPlugin

const RANDOM_AUDIO_STREAM_PLAYER = "RandomAudioStreamPlayer"
const RANDOM_AUDIO_STREAM_PLAYER_2D = "RandomAudioStreamPlayer2D"
const RANDOM_TIMER = "RandomTimer"
const SHAKY_CAMERA_2D = "ShakyCamera2D"

const AUTOLOAD_SCREEN_TRANSITION = "ScreenTransition"

const SETTING_ENABLE_SCREEN_TRANSITION = "addons/node_library/enable_screen_transition"

var screen_transition_scene = preload("scenes/ScreenTransition.tscn")


func _enter_tree():
	add_custom_type(RANDOM_AUDIO_STREAM_PLAYER, "Node", preload("scripts/random_audio_stream_player.gd"), preload("assets/icons/random_audio_stream_player_16x16.png"))
	add_custom_type(RANDOM_AUDIO_STREAM_PLAYER_2D, "Node2D", preload("scripts/random_audio_stream_player_2d.gd"), preload("assets/icons/random_audio_stream_player_2d_16x16.png"))
	add_custom_type(RANDOM_TIMER, "Timer", preload("scripts/random_timer.gd"), preload("assets/icons/random_timer_16x16.png"))
	add_custom_type(SHAKY_CAMERA_2D, "Camera2D", preload("scripts/shaky_camera_2d.gd"), null)

	ProjectSettings.connect("project_settings_changed", self, "on_project_settings_changed")

	if not ProjectSettings.has_setting(SETTING_ENABLE_SCREEN_TRANSITION):
		ProjectSettings.set_setting(SETTING_ENABLE_SCREEN_TRANSITION, false)
	ProjectSettings.set_initial_value(SETTING_ENABLE_SCREEN_TRANSITION, false)


func _exit_tree():
	remove_custom_type(RANDOM_AUDIO_STREAM_PLAYER)
	remove_custom_type(RANDOM_AUDIO_STREAM_PLAYER_2D)
	remove_custom_type(RANDOM_TIMER)
	remove_custom_type(SHAKY_CAMERA_2D)

	remove_autoload_singleton(AUTOLOAD_SCREEN_TRANSITION)


func on_project_settings_changed():
	if ProjectSettings.has_setting(SETTING_ENABLE_SCREEN_TRANSITION) and ProjectSettings.get_setting(SETTING_ENABLE_SCREEN_TRANSITION) == true:
		add_autoload_singleton(AUTOLOAD_SCREEN_TRANSITION, screen_transition_scene.resource_path)
	else:
		remove_autoload_singleton(AUTOLOAD_SCREEN_TRANSITION)
