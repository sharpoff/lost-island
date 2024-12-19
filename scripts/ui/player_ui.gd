extends CanvasLayer

@onready var week_day_time: Label = $UI/VBoxContainer/HBoxContainer/GlobalTime
@onready var hour_minute_time: Label = $UI/VBoxContainer/HBoxContainer2/LocalTime
@onready var player_ui_root: MarginContainer = $UI

@export var options_menu_root: Control
@export var joystick: CanvasLayer

func _ready() -> void:
	# TODO: remove joystick if it's desktop
	if OS.get_model_name() == "GenericDevice":
		joystick.queue_free()

func _on_button_button_up() -> void:
	options_menu_root.show()
	player_ui_root.hide()

func _on_options_menu_closed() -> void:
	player_ui_root.show()
	options_menu_root.hide()

func _on_day_night_cycle_time_changed(week: int, day: int, hour: int, minute: int) -> void:
	var week_str = "%d" % week
	var day_str = "%d" % day
	var hour_str = "%02d" % hour
	var minute_str = "%02d" % minute
	week_day_time.text = "Week " + week_str + ", Day " + day_str
	hour_minute_time.text = hour_str + ":" + minute_str
