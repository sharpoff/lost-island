extends Node2D

const g = 10 # homogeneous gravitational acceleration

func calculate_projectle(node: Node2D, src: Vector2, dst: Vector2):
	# Initial velocity
	var v: float = sqrt(dst.y + sqrt(dst.y**2 + dst.x**2) * g)
	
	dst.y = dst.y
	
	var is_y_reversed = dst.y > 0
	var is_x_reversed = dst.x < 0
	if is_y_reversed:
		dst.y = -dst.y
	if is_x_reversed:
		dst.x = -dst.x
	
	# Angle required to hit coordinate
	var angle = atan((v**2 + sqrt(v**4 - g*(g*dst.x**2 + 2 * dst.y * v**2))) / (g * dst.x))

	print_debug(dst)
	print_debug(angle)
	
	
	# Time of flight to the target's position
	var time_of_flight = dst.x / (v * cos(angle))
	var first_pos = src
	var coords = []
	var t = 0
	var step = 0.1
	while t <= time_of_flight:
		var x: float = v * t * cos(angle)
		var y: float = v * t * sin(angle) - (0.5 * g * (t ** 2))
		var end_pos = Vector2(-x if is_x_reversed else x, -y if is_y_reversed else y)

		coords.append(first_pos)
		coords.append(end_pos)

		first_pos = end_pos
		t += step

	if (len(coords) > 0):
		node.draw_polyline(coords, Color.WHITE, 0.5)
	
	return coords
