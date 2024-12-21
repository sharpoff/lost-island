extends Node2D

var scene_dir_base = "res://scenes/"

var scene_dir_dict = {
	"World": scene_dir_base + "game/world.tscn",
	"Island": scene_dir_base + "game/island_map.tscn",
	"House": scene_dir_base + "game/island_map.tscn",
}

var map_node: Node2D
var gui_node: Node2D

var current_gui_node: Control
var current_map_node: Node2D

enum SceneChange {
	DELETE,
	HIDE,
	REMOVE,
}

enum SceneType {
	GUI,
	MAP,
}

func _ready() -> void:
	current_gui_node = $"World/Map"
	print_debug(current_gui_node)
	load_scene(scene_dir_dict.get("Island"))

func load_scene(scene: String, type: SceneType = SceneType.MAP, state: SceneChange = SceneChange.DELETE) -> void:
	var new_node = load(scene).instantiate()
	
	var current_node
	var selected_node
	match type:
		SceneType.GUI:
			current_node = current_gui_node
			selected_node = gui_node
		SceneType.MAP:
			current_node = current_map_node
			selected_node = map_node

	if current_node == new_node:
		print_debug("Current node is identical to new node, that you are trying to add")
		return

	if state == SceneChange.DELETE and current_node != null:
		current_node.queue_free()
	elif state == SceneChange.HIDE:
		current_node.hide()
	elif state == SceneChange.REMOVE:
		selected_node.remove_child(selected_node)

	current_node = new_node
	selected_node.add_child(new_node)
