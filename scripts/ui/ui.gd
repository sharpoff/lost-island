extends CanvasLayer

@export var joystick: CanvasLayer
@onready var week_day_time: Label = $Info/Margin/Top/Line1/GlobalTime
@onready var hour_minute_time: Label = $Info/Margin/Top/Line2/LocalTime
@onready var coins_label: Label = $Info/Margin/Top/Line4/Coins

var fish_path = "res://resources/items/fish/"

var fish_count = 0
var coins = 0

func _ready() -> void:
	coins_label.text = tr("COINS") + ": " + str(coins)
	SignalBus.connect("increase_fish", increase_fish)
	SignalBus.connect("increase_coins", increase_coins)
	
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

func increase_fish() -> void:
	var fishes = DirAccess.get_files_at(fish_path)
	var fish = load(fish_path + fishes[randi_range(0, len(fishes) - 1)])
	print_debug(fish)
	print_debug(GameManager.current_player.inventory.items)
	for i in range(len(GameManager.current_player.inventory.items)):
		if GameManager.current_player.inventory.items[i] == null:
			print_debug("change ",GameManager.current_player.inventory.items[i], ", index: ", i)
			GameManager.current_player.inventory.items[i] = fish
			break
	print_debug(GameManager.current_player.inventory.items)
	SignalBus.emit_signal("set_inventory_data", GameManager.current_player.inventory)

func increase_coins(amount) -> void:
	coins += amount
	coins_label.text = tr("COINS") + ": " + str(coins)
