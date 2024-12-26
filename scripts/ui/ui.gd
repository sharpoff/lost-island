extends CanvasLayer

@export var joystick: CanvasLayer
@onready var week_day_time: Label = $Info/Margin/Top/Line1/GlobalTime
@onready var hour_minute_time: Label = $Info/Margin/Top/Line2/LocalTime
@onready var fish_count_label: Label = $Info/Margin/Top/Line3/Fish

var fish_count = 0

func _ready() -> void:
	SignalBus.connect("increase_fish", _increase_fish)
	
	# remove joystick if it's desktop
	if OS.get_model_name() == "GenericDevice" and not OS.is_debug_build():
		joystick.queue_free()

func _on_day_night_cycle_time_changed(week: int, day: int, hour: int, minute: int) -> void:
	var week_str = "%d" % week
	var day_str = "%d" % day
	var hour_str = "%02d" % hour
	var minute_str = "%02d" % minute
	week_day_time.text = tr("WEEK") + " " + week_str + ", " + tr("DAY") + " " + day_str
	hour_minute_time.text = hour_str + ":" + minute_str

func _increase_fish() -> void:
	fish_count += 1
	fish_count_label.text = "Fish: " + str(fish_count)
