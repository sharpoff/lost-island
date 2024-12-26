extends Node

signal time_changed(week: int, day: int, hour: int, minute: int)

const MINUTES_IN_WEEK = 10080
const MINUTES_IN_DAY = 1440
const MINUTES_IN_HOUR = 60
const REAL_MINUTE_DURATION = (2 * PI) / MINUTES_IN_DAY # day night cycle is 2 * PI

@export var gradient: GradientTexture1D
@export var time_speed: float = 1.0
@export var current_hour: int = 12: set = set_current_hour

var time: float = 0.0
var last_minute: int = -1

func _ready() -> void:
	time = current_hour * MINUTES_IN_HOUR * REAL_MINUTE_DURATION

func _process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	
	time += delta * time_speed * REAL_MINUTE_DURATION
	var value = (sin(time - PI / 2) + 1.0) / 2.0
	self.color = gradient.gradient.sample(value)
	
	var minute = roundi(time / REAL_MINUTE_DURATION)
	if last_minute < minute:
		last_minute = minute
		_calculate_time()

func _calculate_time() -> void:
	if !is_multiplayer_authority():
		return
	
	var in_game_minute = int(time / REAL_MINUTE_DURATION)
	var day_minutes = in_game_minute % MINUTES_IN_DAY
	@warning_ignore("integer_division")
	var week = int(in_game_minute / MINUTES_IN_WEEK)

	@warning_ignore("integer_division")
	var day = int(in_game_minute / MINUTES_IN_DAY) % 7
	@warning_ignore("integer_division")
	var hour = int(day_minutes / MINUTES_IN_HOUR)
	var minute = day_minutes % MINUTES_IN_HOUR
	
	if (hour > 17):
		var lights = get_tree().get_nodes_in_group("night_light")
		for light in lights:
			light.enabled = true
	elif (hour > 6):
		var lights = get_tree().get_nodes_in_group("night_light")
		for light in lights:
			light.enabled = false
	
	time_changed.emit(week, day, hour, minute)

func set_current_hour(hour):
	current_hour = hour
	time = current_hour * MINUTES_IN_HOUR * REAL_MINUTE_DURATION
