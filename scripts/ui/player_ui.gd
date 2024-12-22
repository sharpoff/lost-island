extends CanvasLayer

@export var week_day_time: Label
@export var hour_minute_time: Label
@export var player_ui_root: MarginContainer
@export var fish_count_label: Label

@export var joystick: CanvasLayer

func _ready() -> void:
	# remove joystick if it's desktop
	if OS.get_model_name() == "GenericDevice" and not OS.is_debug_build():
		joystick.queue_free()

@rpc("call_local")
func _on_day_night_cycle_time_changed(week: int, day: int, hour: int, minute: int) -> void:
	var week_str = "%d" % week
	var day_str = "%d" % day
	var hour_str = "%02d" % hour
	var minute_str = "%02d" % minute
	week_day_time.text = tr("WEEK") + " " + week_str + ", " + tr("DAY") + " " + day_str
	hour_minute_time.text = hour_str + ":" + minute_str
