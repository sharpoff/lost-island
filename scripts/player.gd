extends CharacterBody2D

@export var SPEED = 100.0

@export var animation_tree: AnimationTree

# gameplay related
var last_direction = Vector2(0, 1)

# individual player would have their own coins (maybe all players, think about it)
var coins: int = 0

# movement related
var direction: Vector2
var mouse_pos : Vector2:
	set(pos):
		mouse_pos = Vector2(pos.x, -pos.y)
		queue_redraw()

var current_pos : Vector2:
	set(pos):
		current_pos = Vector2(pos.x, -pos.y)
		queue_redraw()

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _process(delta: float) -> void:
	mouse_pos = get_local_mouse_position()
	current_pos = $Camera2D.position
	
func _physics_process(delta: float) -> void:
	# we can't control other characters only yours
	if not is_multiplayer_authority():
		return
	# let camera follow your network player
	$Camera2D.make_current()
	
	_move()
	_animate()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			pass # something

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

func _draw() -> void:
	# draw fishing rod
	#DrawProjectileUtil.draw_projectile_to(self, current_pos, mouse_pos, 35)
	pass
