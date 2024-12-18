extends Node2D

const GRAVITY = 10
var moving = false
@export var speed: float = 10.0

func _calculate_trajectory(dst: Vector2):
	dst.y = -dst.y
	var src = position
	# Initial velocity
	var v: float = sqrt(dst.y + sqrt(dst.y**2 + dst.x**2) * GRAVITY)
	
	# Angle required to hit coordinate
	var angle = atan((v**2 + sqrt(v**4 - GRAVITY * (GRAVITY * dst.x**2 + 2 * dst.y * v**2))) / (GRAVITY * dst.x))
	# Time of flight to the target's position
	var time_of_flight = dst.x / (v * cos(angle))
	
	var first_pos = src
	var coords = []
	var t = 0
	var step = 0.1
	while t <= time_of_flight:
		var x: float = v * t * cos(angle)
		var y: float = v * t * sin(angle) - (0.5 * GRAVITY * (t ** 2))
		var end_pos = Vector2(x, -y)

		coords.append(first_pos)
		coords.append(end_pos)

		first_pos = end_pos
		t += step
	moving = true
	
	return coords

func update_hook_position(delta: float) -> void:
	if !moving:
		return
	
