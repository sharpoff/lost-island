extends Node

var filename_base = "user://"

var saves_dir = "saves"

var save_filename = "save1"

func save_game() -> void:
	var save_file = FileAccess.open(filename_base + saves_dir.path_join(save_filename), FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("persistent")
	for node in save_nodes:
		if node.scene_file_path.is_empty():
			print_debug("%s node is not an instanced scene, skipped" % node.name)
			continue
		
		if !node.has_method("save"):
			print_debug("%s node doesn't have 'save' method, skipped" % node.name)
			continue

		var node_data = node.call("save")

		var json_string = JSON.stringify(node_data)
	
		save_file.store_line(json_string)
	print_debug("Saved game")

func load_game() -> void:
	if not FileAccess.file_exists(filename_base + saves_dir.path_join(save_filename)):
		return
	print_debug(multiplayer.get_unique_id())
	var save_nodes = get_tree().get_nodes_in_group("persistent")
	for node in save_nodes:
		if !node.is_in_group("player"):
			node.queue_free()

	# load file line by line
	var save_file = FileAccess.open(filename_base + saves_dir.path_join(save_filename), FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		var json = JSON.new()

		if json.parse(json_string) != OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		var node_data = json.data

		# create object and add to a scene
		var new_object
		if get_node(node_data["parent"]).has_node(node_data["name"]):
			# if already loaded change required keys
			new_object = get_node(node_data["parent"]).get_node(node_data["name"])
		else:
			new_object = load(node_data["filename"]).instantiate()
			get_node(node_data["parent"]).add_child(new_object)

		new_object.name = str(node_data["name"])
		new_object.global_position = Vector2(node_data["pos_x"], node_data["pos_y"])

		# set remaining variables
		for key in node_data.keys():
			if key in ["filename", "parent", "pos_x", "pos_y"]:
				continue
			new_object.set(key, node_data[key])
	print_debug("Loaded game")

func add_save(filename):
	var save_file = FileAccess.open(filename_base + saves_dir.path_join(filename), FileAccess.WRITE)
	save_file.close()
	print_debug("new saves: ", get_all_saves())

func get_all_saves():
	var files = DirAccess.get_files_at(filename_base + saves_dir)
	
	return files

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()
		get_tree().quit()
