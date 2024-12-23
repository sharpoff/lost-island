extends CharacterBody2D

signal caught_fish

@export var animation_tree: AnimationTree
# TODO: make this more abstract, so it can use other maps
@onready var tilemap: TileMapLayer
@export var light: PointLight2D
@export var speed_component: SpeedComponent

enum States {
	IDLE,
	MOVING,
	FISHING,
}

var current_state = States.IDLE:
	set(value):
		current_state = value
		_check_current_state(current_state)

# movement related
var direction: Vector2
var last_direction = Vector2(0, 1)
var is_on_stairs = false

func _enter_tree() -> void:
	$AnimationTree.active = true
	set_multiplayer_authority(str(name).to_int())

func _physics_process(delta: float) -> void:
	# we can't control other characters only yours
	if not is_multiplayer_authority():
		return
	# let camera follow your network player
	$Camera2D.make_current()

	_move(delta)
	_animate()

func _move(delta: float):
	# basic movement (wasd, joystick)
	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("up", "down")
	direction = direction.normalized()

	if direction:
		velocity = direction * speed_component.speed
		if is_on_stairs:
			velocity.y += direction.x * speed_component.speed / 2
		current_state = States.MOVING
	else:
		velocity = Vector2.ZERO
		if current_state != States.FISHING:
			current_state = States.IDLE
	move_and_slide()

func _animate():
	if current_state == States.MOVING:
		last_direction = velocity.normalized()

	animation_tree.set("parameters/conditions/idle", current_state == States.IDLE)
	animation_tree.set("parameters/Idle/blend_position", last_direction)

	animation_tree.set("parameters/Fishing start/blend_position", last_direction)

	animation_tree.set("parameters/conditions/fishing", current_state == States.FISHING)
	animation_tree.set("parameters/Fishing Idle/blend_position", last_direction)

	animation_tree.set("parameters/Run/blend_position", last_direction)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if current_state == States.FISHING:
				current_state = States.IDLE
				return

			# TODO: remove tilemap from here
			tilemap = get_tree().root.get_node("Main/World/IslandMap/Ground")

			var tile_data = tilemap.get_cell_tile_data(tilemap.local_to_map(get_global_mouse_position()))
			if tile_data && tile_data.get_custom_data("water"):
				var dst = get_local_mouse_position()
				if $FishingHook._calculate_trajectory(dst):
					current_state = States.FISHING
					if dst.x > 0: # rotate right
						last_direction = Vector2(1, 0)
					elif dst.x < 0: # rotate left
						last_direction = Vector2(-1, 0)

func _on_reaction_bar_ended(is_win: Variant) -> void:
	current_state = States.IDLE
	if is_win:
		get_tree().root.get_node("Main/GUI/PlayerUI")._increase_fish()
	else:
		print_debug("Didn't catch a fish")

func _check_current_state(state) -> void:
	match state:
		States.IDLE:
			$FishingHook.stop_fishing()
			$ReactionBar._end()
		States.FISHING:
			pass
		States.MOVING:
			$FishingHook.stop_fishing()
			$ReactionBar._end()
