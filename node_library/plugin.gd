@tool
extends EditorPlugin

const RANDOM_AUDIO_STREAM_PLAYER = "RandomAudioStreamPlayer"
const RANDOM_AUDIO_STREAM_PLAYER_2D = "RandomAudioStreamPlayer2D"
const RANDOM_TIMER = "RandomTimer"
const SHAKY_CAMERA_2D = "ShakyCamera2D"
const ANIMATOR_CONTROL = "AnimatorControl"

func _enter_tree():
	add_custom_type(RANDOM_AUDIO_STREAM_PLAYER, "AudioStreamPlayer", preload("scripts/random_audio_stream_player.gd"), preload("assets/icons/random_audio_stream_player_16x16.png"))
	add_custom_type(RANDOM_AUDIO_STREAM_PLAYER_2D, "AudioStreamPlayer2D", preload("scripts/random_audio_stream_player_2d.gd"), preload("assets/icons/random_audio_stream_player_2d_16x16.png"))
	add_custom_type(RANDOM_TIMER, "Timer", preload("scripts/random_timer.gd"), preload("assets/icons/random_timer_16x16.png"))
	add_custom_type(SHAKY_CAMERA_2D, "Camera2D", preload("scripts/shaky_camera_2d.gd"), null)
	add_custom_type(ANIMATOR_CONTROL, "Control", preload("scripts/animator_control.gd"), null)


func _exit_tree():
	remove_custom_type(RANDOM_AUDIO_STREAM_PLAYER)
	remove_custom_type(RANDOM_AUDIO_STREAM_PLAYER_2D)
	remove_custom_type(RANDOM_TIMER)
	remove_custom_type(SHAKY_CAMERA_2D)
	remove_custom_type(ANIMATOR_CONTROL)
