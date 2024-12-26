extends Node

var db : SQLite = null

var db_name := "user://database"
var table_name := "game_data"

var test_positions = [Vector2(-537.0, -522.0)]

func save_database() -> void:
	var table_dict : Dictionary = Dictionary()
	
	table_dict["position_x"] = {"data_type": "real", "not_null": true}
	table_dict["position_y"] = {"data_type": "real", "not_null": true}

	db = SQLite.new()
	db.path = db_name
	db.verbosity_level = SQLite.VERBOSE

	db.open_db()
	db.drop_table(table_name)
	db.create_table(table_name, table_dict)
	
	var row_array : Array = []
	var row_dict : Dictionary = Dictionary()
	row_dict["position_x"] = test_positions[0].x
	row_dict["position_y"] = test_positions[0].y
	
	row_array.append(row_dict.duplicate())
	
	db.insert_row(table_name, row_dict)
	row_dict.clear()
	
	
