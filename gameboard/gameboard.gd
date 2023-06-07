extends TileMap

const TILE_TYPE = preload("res://types/TILE_TYPE.gd").TILE_TYPE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_tile_type(pos: Vector2i) -> TILE_TYPE:
	var type: TILE_TYPE = _get_raw_tile_type(pos)
	
	if type == TILE_TYPE.BLUE:
		var dir: Vector2 = Vector2(1, 0)
		for i in range(4):
			var neighbour: TILE_TYPE = _get_raw_tile_type(pos + Vector2i(dir))
			if neighbour == TILE_TYPE.YELLOW:
				type = TILE_TYPE.YELLOW
				break;
			dir = dir.rotated(PI / 2)
	
	return type
			
func _get_raw_tile_type(pos: Vector2i) -> TILE_TYPE:
	var tile: int = get_cell_atlas_coords(0, pos).x
	
	match tile:
		0:
			return TILE_TYPE.PINK
		1:
			return TILE_TYPE.GREEN
		2:
			return TILE_TYPE.RED
		3:
			return TILE_TYPE.YELLOW
		4:
			return TILE_TYPE.ORANGE
		5:
			return TILE_TYPE.PURPLE
		6:
			return TILE_TYPE.BLUE
	return TILE_TYPE.RED
