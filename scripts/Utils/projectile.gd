extends Node2D

const g = 10 # homogeneous gravitational acceleration

func draw_projectile_to(node: Node2D, src: Vector2, dst: Vector2, init_velocity: float):	
	# Angle required to hit coordinate
	var v = init_velocity # to shorten formula
	var angle = atan((v**2 + sqrt(v**4 - g*(g*dst.x**2 + 2 * dst.y * v**2))) / (g * dst.x))
	
	var rotate_angle = false
	if not angle:
		return
	elif angle < 0:
		rotate_angle = true
		angle = -angle
	
	# Time of flight to the target's position
	var time_of_flight = (-dst.x if rotate_angle else dst.x) / (init_velocity * cos(angle))

	var first_pos = src
	var coords = []
	var t = 0
	var step = 0.1
	while t <= time_of_flight:
		var x: float = init_velocity * t * cos(angle)
		var y: float = init_velocity * t * sin(angle) - (0.5 * g * (t ** 2))
		x = -x if rotate_angle else x
		var end_pos = Vector2(x, -y)
		
		coords.append(first_pos)
		coords.append(end_pos)
		
		first_pos = end_pos
		t += step
	
	if (len(coords) > 0):
		node.draw_polyline(coords, Color.WHITE, 0.5)

func draw_curve_to(node: Node2D, src: Vector2, dst: Vector2):
	pass
