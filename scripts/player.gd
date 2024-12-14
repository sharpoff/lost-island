extends CharacterBody2D

@export var SPEED = 100.0
@onready var tilemap: TileMapLayer = $"../Background"

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
	astar.region = tilemap.get_used_rect()
	astar.cell_size = Vector2(32, 32)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	print(astar.region)

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
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	move_and_slide()
	
	## basic movement (wasd, joystick)
	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("up", "down")
	direction = direction.normalized()

	if direction:
		velocity = direction * SPEED
		current_id_path = []
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		state = States.IDLE
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			# create new path for a*
			var id_path = astar.get_id_path(
				tilemap.local_to_map(global_position),
				tilemap.local_to_map(get_global_mouse_position())
			).slice(1)
			
			if not id_path.is_empty():
				current_id_path = id_path
