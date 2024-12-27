extends Node2D
class_name FishingHook

@onready var hook: Polygon2D = $Hook
@export var speed_multiplier: float = 10

const GRAVITY = 10

var initial_pos: Vector2
var destination_pos: Vector2
var initial_velocity: float
var required_angle: float
var time_of_flight: float

enum Direction {
	RIGHT,
	LEFT
}

var throw_direction: Direction = Direction.LEFT
var elapsed_time: float = 0.0
var draw_list: Array[Vector2]

var is_thrown = false:
	set(value):
		is_thrown = value
		if is_thrown == false:
			draw_list = []
			hook.hide()
			queue_redraw()

var is_moving = false

func _physics_process(delta: float) -> void:
	if elapsed_time <= time_of_flight:
		update_hook_position(delta)
	if is_thrown:
		queue_redraw()

func _draw() -> void:
	if draw_list.size() >= 2:
		draw_polyline(draw_list, Color.WHITE, 0.5)

func throw_hook(target: Vector2):
	hook.show()
	draw_list = []
	initial_pos = global_position
	destination_pos = target - initial_pos # normalize
	destination_pos.x = abs(destination_pos.x)
	throw_direction = Direction.LEFT if target.x < initial_pos.x else Direction.RIGHT
	destination_pos.y *= -1 # if you do not want to draw upside down

	# Initial velocity
	initial_velocity = sqrt(destination_pos.y + sqrt(destination_pos.y**2 + destination_pos.x**2) * GRAVITY)
	# Angle required to hit coordinate
	required_angle = atan((initial_velocity**2 + sqrt(initial_velocity**4 - GRAVITY * (GRAVITY * destination_pos.x**2 + 2 * destination_pos.y * initial_velocity**2))) / (GRAVITY * destination_pos.x))
	# Time of flight to the target's position
	time_of_flight = destination_pos.x / (initial_velocity * cos(required_angle))

	#print_debug("initial velocty: %s" % initial_velocity)
	#print_debug("required angle: %s" % required_angle)
	#print_debug("time of flight: %s" % time_of_flight)
	
	elapsed_time = 0.0
	is_thrown = true
	is_moving = true

func update_hook_position(delta: float) -> void:
	elapsed_time += delta * speed_multiplier
	var x: float = initial_velocity * elapsed_time * cos(required_angle)
	x = x * -1 if throw_direction == Direction.LEFT else x
	var y: float = initial_velocity * elapsed_time * sin(required_angle) - (0.5 * GRAVITY * (elapsed_time ** 2))
	draw_list.append(Vector2(x, -y))

	hook.position = Vector2(x, -y)
