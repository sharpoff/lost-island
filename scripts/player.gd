extends CharacterBody2D

@export var SPEED = 100.0
@onready var tilemap: TileMapLayer = $"../Background"
@onready var joystick: Control = $"../UI/TouchControls/Virtual Joystick"

enum States {IDLE, FISHING, MOVING}
var state: States = States.IDLE

var direction: Vector2
var is_clicked = false

# astar movement related
var astar = AStarGrid2D.new()
var current_id_path: Array[Vector2i]

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	var tilemap_size = tilemap.get_used_rect().end - tilemap.get_used_rect().position
	var tilemap_region = Rect2i(tilemap.get_used_rect().position, tilemap_size)
	astar.region = tilemap_region
	astar.cell_size = tilemap.tile_set.tile_size
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.update()

func _physics_process(delta: float) -> void:
	# we can't control other characters only yours
	if not is_multiplayer_authority():
		return
	# let camera follow your network player
	$Camera2D.make_current()
	
	# touch/click movement
	if not current_id_path.is_empty():
		var target = tilemap.map_to_local(current_id_path.front())
		global_position = global_position.move_toward(target, SPEED * delta)
		if global_position == target:
			current_id_path.pop_front()
		state = States.MOVING
		move_and_slide()
		
		print(current_id_path)
		return
	else:
		state = States.IDLE
	
	## basic movement (wasd, joystick)
	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("up", "down")
	direction = direction.normalized()

	if direction:
		velocity = direction * SPEED
		current_id_path = []
		state = States.MOVING
	else:
		velocity = Vector2.ZERO
		state = States.IDLE
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			# create new path for a* if player is not moving right now
			var mouse_pos = get_global_mouse_position()
			if state != States.MOVING:
				var id_path = astar.get_id_path(
					tilemap.local_to_map(global_position),
					tilemap.local_to_map(mouse_pos)
				).slice(1)
				
				if not id_path.is_empty():
					current_id_path = id_path
