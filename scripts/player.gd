extends CharacterBody2D

@export var SPEED = 100.0
enum States {IDLE, FISHING, MOVING}

var direction: Vector2
var state: States = States.IDLE

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _physics_process(delta: float) -> void:
	# we can't control other characters only yours
	if not is_multiplayer_authority():
		return
	# let camera follow current right network player
	$Camera2D.make_current()
	
	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("up", "down")

	if direction:
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	
	move_and_slide()
