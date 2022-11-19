tool
extends Timer

export(float) var min_wait_time = 1 setget set_min_wait_time, get_min_wait_time
export(float) var max_wait_time = 1.5 setget set_max_wait_time, get_max_wait_time

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	if (autostart && !Engine.editor_hint):
		start()


func start(time_sec: float = -1):
	if (time_sec > 0):
		.start(time_sec)
	else:
		var wait_time = rng.randf_range(min_wait_time, max_wait_time)
		.start(wait_time)


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
