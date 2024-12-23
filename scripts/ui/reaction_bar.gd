extends Control

signal ended(is_win)

@onready var bar: NinePatchRect = $Bar
@onready var hitter: TextureRect = $Hitter
@export var limit: int = 3
@export var fishing_hook: Node2D
# TODO: add speed with right delta
var speed: int = 1

var is_running: bool = false
var hits: int = 0

var bar_start: int = -29
var bar_end: int = 25
var win_start: int = 8
var win_end: int = 14

func _ready():
	hide()
	fishing_hook.timeout.connect(_start)

func _process(_delta: float) -> void:
	if is_running:
		hitter.position.x += speed
		if hitter.position.x < bar_start or hitter.position.x > bar_end: # reverse direction
			speed *= -1
			hits += 1

		if hits > limit:
			ended.emit(false)
			_end()

		if Input.is_action_just_pressed("interact"):
			var is_win = false
			if hitter.position.x >= win_start and hitter.position.x <= win_end:
				is_win = true
			ended.emit(is_win)
			_end()

func _start() -> void:
	is_running = true
	show()

func _end() -> void:
	is_running = false
	hits = 0
	hitter.position.x = bar_start
	hide()
