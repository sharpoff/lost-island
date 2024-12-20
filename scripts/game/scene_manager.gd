extends Node2D

@export_file("*.tscn") var world_scene: String

@export var map_node: Node2D
@export var gui_node: Control

var current_gui_node: Control
var current_map_node: Node2D

enum SceneChange {
	DELETE_SCENE,
	HIDE_SCENE,
	REMOVE_SCENE,
}

enum NodeType {
	GUI_NODE,
	MAP_NODE,
}

func _ready() -> void:
	pass

func change_current_gui(scene: PackedScene, type: NodeType, state: SceneChange = SceneChange.DELETE_SCENE) -> void:
	var new_node = scene.instantiate()
	if current_gui_node == new_node:
		print_debug("Current node is identical to new node")
		return

	current_gui_node = new_node
	gui_node.add_child(new_node)

	if state == SceneChange.DELETE_SCENE:
		current_gui_node.queue_free()
	elif state == SceneChange.HIDE_SCENE:
		current_gui_node.hide()
	elif state == SceneChange.REMOVE_SCENE:
		gui_node.remove_child(current_gui_node)

func change_current_map(scene: PackedScene, type: NodeType, state: SceneChange = SceneChange.DELETE_SCENE) -> void:
	var new_node = scene.instantiate()
	if current_map_node == new_node:
		print_debug("Current node is identical to new node")
		return

	current_map_node = new_node
	map_node.add_child(new_node)

	if state == SceneChange.DELETE_SCENE:
		current_map_node.queue_free()
	elif state == SceneChange.HIDE_SCENE:
		current_map_node.hide()
	elif state == SceneChange.REMOVE_SCENE:
		map_node.remove_child(current_map_node)
