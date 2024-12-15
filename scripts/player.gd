extends CharacterBody2D

@export var SPEED = 100.0

@export var animation_tree: AnimationTree

# gameplay related
enum States {IDLE, FISHING, MOVING}
var state: States = States.IDLE

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
		state = States.MOVING
	else:
		velocity = Vector2.ZERO
		state = States.IDLE
	move_and_slide()

func _animate():
	animation_tree.set("parameters/blend_position", direction)

func _draw() -> void:
	# draw fishing rod
	DrawProjectileUtil.draw_projectile_to(self, current_pos, mouse_pos, 35)
