extends CanvasLayer

@export var week_day_time: Label
@export var hour_minute_time: Label

func _on_button_button_up() -> void:
	$OptionsMenu.show()
	$UI.hide()
	


func _on_options_menu_closed() -> void:
	$UI.show()
	$OptionsMenu.hide()


func _on_day_night_cycle_time_changed(weeks: int, days: int, hours: int, minutes: int) -> void:
	week_day_time.text = "Week " + str(weeks) + ", Day " + str(days)
	hour_minute_time.text = str(hours) + ":" + str(minutes)
