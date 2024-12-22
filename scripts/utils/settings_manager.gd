extends Node

var master_volume: float = 100.0
var sound_effects_volume: float = 100.0

enum Languages {ENGLISH, RUSSIAN}
var language = Languages.ENGLISH

func _ready() -> void:
	if !load_config(): # if can't load config, save defaults
		save_config()

func save_config() -> void:
	var config = ConfigFile.new()
	config.set_value("Settings", "language", language)
	config.set_value("Settings", "master_volume", master_volume)
	config.set_value("Settings", "sound_effects_volume", sound_effects_volume)

	config.save("user://Settings.cfg")

	load_config()

func load_config() -> bool:
	var config = ConfigFile.new()
	var err = config.load("user://Settings.cfg")
	
	if err != OK:
		print_debug("Failed to load config file.")
		return false
	
	var new_language = config.get_value("Settings", "language")
	if new_language != null:
		language = new_language
		change_language()
	
	var new_master_volume = config.get_value("Settings", "master_volume")
	if new_master_volume != null:
		master_volume = new_master_volume
	
	var new_sound_effects_volume = config.get_value("Settings", "sound_effects_volume")
	if new_sound_effects_volume != null:
		sound_effects_volume = new_sound_effects_volume

	return true

func change_language():
	match language:
		Languages.RUSSIAN:
			TranslationServer.set_locale("ru")
		Languages.ENGLISH:
			TranslationServer.set_locale("en")
