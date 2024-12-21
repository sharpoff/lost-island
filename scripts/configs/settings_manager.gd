extends Node

var master_volume: float = 100.0
var sound_effects_volume: float = 100.0

enum Languages {ENGLISH, RUSSIAN}
var current_state = Languages.ENGLISH

var config = ConfigFile.new()

func _ready() -> void:
	save_config()

func save_config() -> void:
	config.set_value("Settings", "master_volume", master_volume)
	config.set_value("Settings", "sound_effects_volume", sound_effects_volume)
	
	config.save("user://Settings.cfg")

func load_config() -> void:
	var err = config.load("user://Settings.cfg")
	
	if err != OK:
		print_debug("Failed to load config file.")
		return

	var new_master_volume = config.get_value("Settings", "master_volume")
	if new_master_volume != null:
		master_volume = new_master_volume
	var new_sound_effects_volume = config.get_value("Settings", "sound_effects_volume")
	if new_sound_effects_volume != null:
		sound_effects_volume = new_sound_effects_volume
