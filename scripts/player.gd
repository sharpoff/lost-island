extends CharacterBody2D

@export var SPEED = 100.0

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _process(delta: float) -> void:
	# we can't control other characters only yours
	if not is_multiplayer_authority():
		return
	
	# let camera follow current player
	$Camera2D.make_current()
	
	var speed = SPEED * delta
	var velocity = Vector2.ZERO # The player's movement vector.
	
	if Input.is_action_pressed("down"):
		velocity.y += speed
	if Input.is_action_pressed("up"):
		velocity.y -= speed
	if Input.is_action_pressed("left"):
		velocity.x -= speed
	if Input.is_action_pressed("right"):
		velocity.x += speed
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		
	position += velocity * delta
