extends CharacterBody2D

@export var SPEED = 100.0
@export var animation_tree: AnimationTree
@onready var tilemap: TileMapLayer = $"../Background"

# movement related
var direction: Vector2
var last_direction = Vector2(0, 1)
var mouse_pos : Vector2

var current_pos : Vector2

# gameplay related
var coins: int = 0 # individual player would have their own coins (maybe all players, think about it)


func _enter_tree() -> void:
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
			mouse_pos = get_local_mouse_position()
			var tile_pos = tilemap.local_to_map(mouse_pos)
			var tile_data = tilemap.get_cell_tile_data(tile_pos)
			if tile_data.get_custom_data('water'):
				print("water")

			current_pos = $Camera2D.position

func _draw() -> void:
	pass
	# draw fishing rod
	# limit destination
	#var src = current_pos
	#var dst = mouse_pos
	#
	#if (dst.y < src.y - 20) or (dst.y > src.y + 20):
		#ProjectileUtil.draw_curve_to(self, current_pos, mouse_pos)
#
	#var init_velocity = 35
	#ProjectileUtil.draw_projectile_to(self, current_pos, mouse_pos, init_velocity)
