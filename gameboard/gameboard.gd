extends TileMap

@export var width: int = 5
@export var height: int = 5

const TILE_TYPE = preload("res://types/tile_type.gd").TILE_TYPE


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var seed: int = $"/root/GameManager".tile_seed
	if seed == 0:
		seed = randi()
	var label: RichTextLabel = $"../UICanvas/Pause/SeedLabel"
	label.text = "Seed: " + str(seed)
	print("seed: ", seed)
	for y in range(height):
		for x in range(width):
			var rand: int = rand_from_seed(seed)[0]
			seed = rand
			var tile: int = rand % (len(TILE_TYPE) - 1)
			set_cell(0, Vector2i(x, y), 0, Vector2i(tile, 0))
			
	set_cell(0, Vector2i(0, 0), 0, Vector2i(0, 0))	
	set_cell(0, Vector2i(0, 1), 0, Vector2i(6, 0))	


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
	if tile < 0:
		return TILE_TYPE.RED
		
	return TILE_TYPE[TILE_TYPE.keys()[tile]]
