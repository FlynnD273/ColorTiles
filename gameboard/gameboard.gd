extends TileMap

@export var width: int = 5
@export var height: int = 5
@export var min_complexity: float = 1
@export var max_complexity: float = 3

const TILE_TYPE = preload("res://types/tile_type.gd").TILE_TYPE
var tile_seed: int


func set_tile(pos: Vector2i, type: TILE_TYPE) -> void:
	set_cell(0, pos, 0, Vector2i(type, 0))


#func rand_range(minimum: int, maximum: int = -1) -> int:
#	if maximum == -1:
#		maximum = minimum
#		minimum = 0
#	var rand: int = rand_from_seed(tile_seed)[0]
#	tile_seed = rand
#	return (rand % (maximum - minimum)) + minimum


func generate_tiles() -> void:
	const dirs: Array[Vector2i] = [ Vector2i.RIGHT, Vector2i.UP, Vector2i.LEFT, Vector2i.DOWN ]
	var path: Array[Vector2i] = []
	var taken_dirs: Array[int] = []
	var count: int = 0
	
	path.append(Vector2i(0, randi_range(0, height - 1)))
	taken_dirs.append(0)
	
	while path[-1].x != width - 1:
		count += 1
		if len(path) == 0 or count > max_complexity * (width + height):
			count = 0
			path = [ Vector2i(0, randi_range(0, height - 1)) ]
			taken_dirs = [ 0 ]
			continue
		
		if taken_dirs[-1] == 0b111:
			path = path.slice(0, len(path) - 1)
			taken_dirs = taken_dirs.slice(0, len(taken_dirs) - 1)
			continue
		
		var possible_dirs: Array[int] = []
		var current: Vector2i = path[-1]
		
		for i in range(len(dirs)):
			var dir: Vector2i = dirs[i]
			var next: Vector2i = current + dir
			if next.x < 0 or next.y < 0 or next.x >= width or next.y >= height:
				continue
			if (taken_dirs[-1] >> i) & 0b1:
				continue
			if next in path:
				continue
			
			possible_dirs.append(i)
	
		if len(possible_dirs) == 0:
			path = path.slice(0, len(path) - 1)
			taken_dirs = taken_dirs.slice(0, len(taken_dirs) - 1)
			continue
		
		var dir_index: int = possible_dirs[randi_range(0, len(possible_dirs) - 1)]
		var move: Vector2i = dirs[dir_index]
		
		taken_dirs[-1] |= (0b1 << dir_index)
		taken_dirs.append(0)
		path.append(current + move)
	
	if min_complexity * (width + height) > len(path):
		generate_tiles()
		return
	
	for y in range(height):
		for x in range(width):
#			set_tile(Vector2i(x, y), randi_range(0, len(TILE_TYPE) - 2))
			set_tile(Vector2i(x, y), TILE_TYPE.RED)


	for tile in path:
		set_tile(tile, TILE_TYPE.PINK)
	
	set_tile(path[-1], TILE_TYPE.GREEN)
	$"../Player".call_deferred("set_start", path[0])	
	
	
#	set_cell(0, Vector2i(0, 0), 0, Vector2i(0, 0))
#	set_cell(0, Vector2i(0, 1), 0, Vector2i(6, 0))


func _ready() -> void:
	tile_seed = $"/root/GameManager".tile_seed
	if tile_seed == 0:
		tile_seed = randi()
	print(tile_seed)
	seed(tile_seed)
	var label: RichTextLabel = $"../UICanvas/Pause/SeedLabel"
	label.text = "Seed: " + str(tile_seed)
	
	generate_tiles()


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
