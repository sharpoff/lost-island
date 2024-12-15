extends TileMapLayer
class_name AstarTileMap

var astar = AStarGrid2D.new()

func _ready() -> void:
	var tilemap_size = get_used_rect().end - get_used_rect().position
	var map_region = Rect2i(get_used_rect().position, tilemap_size)
	astar.region = map_region
	astar.cell_size = tile_set.tile_size
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.update()
