extends CharacterBody2D
class_name Player

@export var animation_tree: AnimationTree
# TODO: make this more abstract, so it can use other maps
@export var light: PointLight2D
@export var speed_component: SpeedComponent
@export var inventory: InventoryData
@export var hotbar: InventoryData
@export var fishing_hook: FishingHook

var selected_item: ItemData = null

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
var can_move = true
var can_click = true
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
	if !can_move:
		return
	
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
	if can_click and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if current_state == States.FISHING:
				current_state = States.IDLE
				return

			if selected_item and selected_item.name != "Fishing rod":
				return
			
			#var difference = abs(get_local_mouse_position()) - abs(position)
			#if difference.x > 150 or difference.y > 150:
				#print_debug("work")
				#return

			# TODO: remove tilemaps from here and remove boilerplate code to a function
			var tilemap_ground: TileMapLayer = get_tree().root.get_node("Main/World/IslandMap/Ground")
			var tilmap_above_ground: TileMapLayer = get_tree().root.get_node("Main/World/IslandMap/AboveGround")
			if !tilemap_ground:
				print_debug("tilemap ground not found")
				pass
			elif !tilmap_above_ground:
				print_debug("Tilemaps not found")
				return

			var ground_pos = tilemap_ground.local_to_map(tilemap_ground.get_local_mouse_position())
			var above_ground_pos = tilmap_above_ground.local_to_map(tilmap_above_ground.get_local_mouse_position())
			if !ground_pos or !above_ground_pos:
				print_debug("tilemap position out of bounds")
				return

			var ground_data = tilemap_ground.get_cell_tile_data(ground_pos)
			var above_ground_data = tilmap_above_ground.get_cell_tile_data(above_ground_pos)

			var is_water = ground_data and ground_data.get_custom_data("water")
			var is_elevate = above_ground_data and above_ground_data.get_custom_data("elevate")

			if is_water and !is_elevate:
				var target = get_global_mouse_position()
				# rotate player to clicked position
				last_direction = get_local_mouse_position().normalized()
				fishing_hook.throw_hook(target)
				current_state = States.FISHING

func _on_reaction_bar_started() -> void:
	can_move = false
	can_click = false

func _on_reaction_bar_ended(is_win: Variant) -> void:
	current_state = States.IDLE
	can_move = true
	can_click = true

	if is_win:
		SignalBus.emit_signal("increase_fish")
	else:
		print_debug("Didn't catch a fish")

func _check_current_state(state) -> void:
	match state:
		States.IDLE:
			fishing_hook.is_thrown = false
			$ReactionBar._end()
		States.FISHING:
			pass
		States.MOVING:
			fishing_hook.is_thrown = false
			$ReactionBar._end()
