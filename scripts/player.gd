extends CharacterBody2D

const SPEED = 500.0

func _process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
