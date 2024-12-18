extends CharacterBody2D

@export var animation_tree: AnimationTree
@onready var tilemap: TileMapLayer = $"../Ground"
@export var light: PointLight2D
@export var speed_component: SpeedComponent

# movement related
var direction: Vector2
var last_direction = Vector2(0, 1)

# gameplay related
var coins: int = 0 # individual player would have their own coins (maybe all players, think about it)

func _enter_tree() -> void:
	if not NetworkManager.is_single_player:
		set_multiplayer_authority(name.to_int())

func _physics_process(_delta: float) -> void:
	# we can't control other characters only yours
	if not is_multiplayer_authority():
		return
	# let camera follow your network player
	$Camera2D.make_current()

	_move()
	_animate()

func _move():
	# basic movement (wasd, joystick)
	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("up", "down")
	direction = direction.normalized()

	if direction:
		velocity = direction * speed_component.speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func _animate():
	var idle = !velocity
	if !idle:
		last_direction = velocity.normalized()
	
	animation_tree.set("parameters/Run/blend_position", last_direction)
	animation_tree.set("parameters/Idle/blend_position", last_direction)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			# check if clicked tile name
			var mouse_pos = get_global_mouse_position()
			if not mouse_pos:
				return
			var tile_data = tilemap.get_cell_tile_data(tilemap.local_to_map(mouse_pos))
			var is_water = tile_data.get_custom_data("water")
			
			queue_redraw()

func _draw() -> void:
	var dst = get_local_mouse_position()
	var coords = $FishingHook._calculate_trajectory(dst)
	draw_polyline(coords, Color.WHITE, 0.5)
	
func turn_on_light() -> void:
	light.enabled = true

func turn_off_light() -> void:
	light.enabled = false
