extends CharacterBody2D

@export var animation_tree: AnimationTree
@onready var tilemap: TileMapLayer = $"../Ground"
@export var light: PointLight2D
@export var speed_component: SpeedComponent

enum States {
	IDLE,
	MOVING,
	FISHING,
}

var current_state = States.IDLE

# movement related
var direction: Vector2
var last_direction = Vector2(0, 1)

# gameplay related
var coins: int = 0

func _enter_tree() -> void:
	if not NetworkManager.is_single_player:
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
		velocity = direction * speed_component.speed
		current_state = States.MOVING
		$FishingHook.stop_fishing()
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

	animation_tree.set("parameters/conditions/fishing", current_state == States.FISHING)
	animation_tree.set("parameters/Fishing/blend_position", last_direction)
	
	animation_tree.set("parameters/Run/blend_position", last_direction)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if current_state == States.FISHING:
				current_state = States.IDLE
				$FishingHook.stop_fishing()
				return
			# check if clicked tile name
			var mouse_pos = get_global_mouse_position()
			if not mouse_pos:
				return
			var tile_data = tilemap.get_cell_tile_data(tilemap.local_to_map(mouse_pos))
			var is_water
			if tile_data:
				is_water = tile_data.get_custom_data("water")
			if is_water:
				var dst = get_local_mouse_position()
				if $FishingHook._calculate_trajectory(dst):
					current_state = States.FISHING
					if dst.x > 0: # rotate right
						last_direction = Vector2(1, 0)
					elif dst.x < 0: # rotate left
						last_direction = Vector2(-1, 0)

func _on_fishing_hook_stopped_fishing() -> void:
	current_state = States.IDLE
