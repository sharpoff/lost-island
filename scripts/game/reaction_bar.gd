extends Control

@onready var bar: TextureRect = $Bar
@onready var hitter: TextureRect = $Hitter
@export var limit: int = 3

var acc_time: float = 0.0

var x_start: int = -29
var x_end: int = 25

var speed: int = 1
var is_running: bool = false
var hits: int = 0

func _ready() -> void:
	_start()

func _process(delta: float) -> void:
	if is_running:
		hitter.position.x += speed
		if hitter.position.x < x_start or hitter.position.x > x_end: # reverse direction
			speed *= -1
			hits += 1
		if hits > limit:
			is_running = false

func _start() -> void:
	is_running = true

func _end() -> void:
	is_running = false
