extends Node2D

signal stopped_fishing

@onready var hook: Polygon2D = $Hook
@onready var fish_timer: Timer = $FishTimer
@export_color_no_alpha var color_flying: Color
@export_color_no_alpha var color_land: Color
@export var hook_color: Color

const GRAVITY = 10
var coords: Array[Vector2] = []
var current_drawn: Array[Vector2] = []

var fish_time = 0.0:
	set(value):
		fish_time = value
		fish_timer.wait_time = fish_time

var is_moving = false:
	set(value):
		is_moving = value
		if is_moving:
			fish_timer.start()

var is_fishing = false:
	set(value):
		is_fishing = value
		if !is_fishing :
			hook.hide()
		else:
			hook.show()
		queue_redraw()

func _ready() -> void:
	hook.color = hook_color
	_randomize_fish_time()
	stopped_fishing.connect(stop_fishing)

func _calculate_trajectory(dst: Vector2, reverse_y: bool = false, increase_vel: float = 0.0):
	dst -= position # remove offsets between mouse position and hook position
	var reverse_x = dst.x < 0
	if reverse_x: # if throwing to the left reverse it
		dst.x = abs(dst.x)
	if !reverse_y: # if you do not want to draw upside down
		dst.y = -dst.y

	# Initial velocity
	var v: float = sqrt(dst.y + sqrt(dst.y**2 + dst.x**2) * GRAVITY) + increase_vel
	# Angle required to hit coordinate
	var angle = atan((v**2 + sqrt(v**4 - GRAVITY * (GRAVITY * dst.x**2 + 2 * dst.y * v**2))) / (GRAVITY * dst.x))
	# Time of flight to the target's position
	var time_of_flight = dst.x / (v * cos(angle))

	#print_debug(v)
	#print_debug(angle)
	#print_debug(time_of_flight)
	
	coords = []
	current_drawn = []
	var first_pos = Vector2()
	var t = 0
	var step = 0.1
	
	while t <= time_of_flight:
		var x: float = v * t * cos(angle)
		var y: float = v * t * sin(angle) - (0.5 * GRAVITY * (t ** 2))
		var end_pos = Vector2(-x if reverse_x else x, y if reverse_y else -y)

		coords.append(first_pos)
		coords.append(end_pos)

		first_pos = end_pos
		t += step
	
	if coords:
		is_moving = true
		is_fishing = true
		return true
	
	return false

func update_hook_position() -> void:
	if len(coords) < 2:
		is_moving = false
		return
	
	var start = coords.pop_front()
	var end = coords.pop_front()
	current_drawn.append(start)
	current_drawn.append(end)
	
	hook.position = end
	draw_polyline(current_drawn, color_flying, 0.5)

func _process(_delta: float) -> void:
	if is_moving or !current_drawn.is_empty() or is_fishing:
		queue_redraw()

func _draw() -> void:
	if !is_fishing:
		return

	if is_moving:
		update_hook_position()
	elif current_drawn.size() >= 2:
		draw_polyline(current_drawn, color_land, 0.5)

func _randomize_fish_time():
	fish_time = randf_range(6.0, 10.0) # reset time

func _on_fish_timer_timeout() -> void:
	stopped_fishing.emit()

func stop_fishing():
	_randomize_fish_time()
	is_fishing = false
