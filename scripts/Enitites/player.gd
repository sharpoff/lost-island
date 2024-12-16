extends CharacterBody2D

@export var SPEED = 100.0
@export var animation_tree: AnimationTree
@onready var tilemap: TileMapLayer = $"../Background"

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
		velocity = direction * SPEED
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
			var tile_data = tilemap.get_cell_tile_data(tilemap.local_to_map(get_global_mouse_position()))
			var is_water = tile_data.get_custom_data("water")
			queue_redraw()

func _draw() -> void:
	var src = $Camera2D.position
	var dst = get_local_mouse_position()

	if (dst.y < src.y - 20) or (dst.y > src.y + 20):
		ProjectileUtil.draw_curve_to(self, src, dst)
	else:
		var init_velocity = 35
		ProjectileUtil.draw_projectile_to(self, src, dst, init_velocity)
