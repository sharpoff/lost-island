extends CharacterBody2D

@export var SPEED = 100.0

# gameplay related
enum States {IDLE, FISHING, MOVING}
var state: States = States.IDLE

# individual player would have their own coins (maybe all players, think about it)
var coins: int = 0

# movement related
var direction: Vector2

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _physics_process(delta: float) -> void:
	# we can't control other characters only yours
	if not is_multiplayer_authority():
		return
	
	# let camera follow your network player
	$Camera2D.make_current()
	
	_move()
	#_animation() - animation goes here i guess
	

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
