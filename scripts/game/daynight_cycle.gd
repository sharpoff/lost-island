extends Node

const MINUTES_IN_WEEK = 10080
const MINUTES_IN_DAY = 1440
const MINUTES_IN_HOUR = 60
const REAL_MINUTE_DURATION = (2 * PI) / MINUTES_IN_DAY # day night cycle is 2 * PI

@export var gradient: GradientTexture1D
@export var time_speed = 1.0

var time: float = 0.0
var last_minute: int = -1

signal time_changed(week: int, day: int, hour: int, minute: int)

func _process(delta: float) -> void:
	time += delta * time_speed * REAL_MINUTE_DURATION
	var value = (sin(time - PI / 2) + 1.0) / 2.0
	self.color = gradient.gradient.sample(value)
	
	var minute = roundi(time / REAL_MINUTE_DURATION)
	if last_minute < minute:
		last_minute = minute
		_calculate_time()

func _calculate_time() -> void:
	var in_game_minute = int(time / REAL_MINUTE_DURATION)

	var day_minutes = in_game_minute % MINUTES_IN_DAY
	var week = int(in_game_minute / MINUTES_IN_WEEK)

	var day = int(in_game_minute / MINUTES_IN_DAY) % 7
	
	var hour = int(day_minutes / MINUTES_IN_HOUR)
	var minute = day_minutes % MINUTES_IN_HOUR
	
	time_changed.emit(week, day, hour, minute)
