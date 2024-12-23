extends CharacterBody2D

@export var animation_tree: AnimationTree
# TODO: make this more abstract, so it can use other maps
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

			var mouse_pos = get_global_mouse_position()
			if !mouse_pos:
				print_debug("mouse position is null")
				return
			
			var is_elevate = true
			var is_water = true

			# TODO: remove tilemaps from here
			var tilemap_ground = get_tree().root.get_node("Main/World/IslandMap/Ground")
			var tilmap_above_ground = get_tree().root.get_node("Main/World/IslandMap/AboveGround")
			if !tilemap_ground:
				print_debug("tilemap ground not found")
				pass
			elif !tilmap_above_ground:
				print_debug("Tilemaps not found")
				return

			var ground_pos = tilemap_ground.local_to_map(mouse_pos)
			var above_ground_pos = tilmap_above_ground.local_to_map(mouse_pos)
			if !ground_pos or !above_ground_pos:
				print_debug("tilemap position out of bounds")
				return

			var ground_data = tilemap_ground.get_cell_tile_data(ground_pos)
			var above_ground_data = tilmap_above_ground.get_cell_tile_data(above_ground_pos)
			if !ground_data or !above_ground_data:
				print_debug("Data of tilemaps not found")
				return

			is_water = is_water and ground_data.get_custom_data("water")
			is_elevate = is_elevate and above_ground_data.get_custom_data("elevate")

			if is_water and !is_elevate:
				var dst = mouse_pos
				if $FishingHook._calculate_trajectory(dst):
					current_state = States.FISHING
					if dst.x > 0: # rotate right
						last_direction = Vector2(1, 0)
					elif dst.x < 0: # rotate left
						last_direction = Vector2(-1, 0)

func _on_reaction_bar_ended(is_win: Variant) -> void:
	current_state = States.IDLE
	if is_win:
		# TODO: make it abstract and better
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
