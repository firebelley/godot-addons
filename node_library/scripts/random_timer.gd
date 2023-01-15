@tool
extends Timer
class_name RandomTimer

@export var min_wait_time: float = 1 : get = get_min_wait_time, set = set_min_wait_time
@export var max_wait_time: float = 1.5 : get = get_max_wait_time, set = set_max_wait_time

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	if (autostart && !Engine.is_editor_hint()):
		start_random()


func start_random(time_sec: float = -1.0):
	if (time_sec > 0):
		super.start(time_sec)
	else:
		super.start(rng.randf_range(min_wait_time, max_wait_time))


func set_min_wait_time(val: float):
	if val < 0:
		min_wait_time = 0;
	else:
		min_wait_time = val


func get_min_wait_time():
	return min_wait_time


func set_max_wait_time(val: float):
	if val < 0:
		max_wait_time = 0;
	else:
		max_wait_time = val


func get_max_wait_time():
	return max_wait_time
