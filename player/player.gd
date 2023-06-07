extends Sprite2D

@export var speed: float = 3
@export var gameboard: TileMap

const TILE_TYPE = preload("res://types/TILE_TYPE.gd").TILE_TYPE
enum FLAVOURS { ORANGE, LEMON }

var next_move: Vector2i
var move_tween: Tween
var grid_position: Vector2i
var flavour: FLAVOURS = FLAVOURS.LEMON

var inputs = {"ui_right": Vector2i.RIGHT,
			  "ui_left": Vector2i.LEFT,
			  "ui_up": Vector2i.UP,
			  "ui_down": Vector2i.DOWN}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move_tween != null and move_tween.is_running():
		return
	
	if next_move != Vector2i.ZERO:
		move(next_move)
		return
		
	for dir in inputs.keys():
		if Input.is_action_pressed(dir):
			move(inputs[dir])

func _unhandled_input(event: InputEvent) -> void:
	pass
			
func move(dir: Vector2i) -> void:
	next_move = Vector2i.ZERO	
	var type: TILE_TYPE = gameboard.get_tile_type(grid_position + dir)
	if type == TILE_TYPE.RED:
		return
		
	var new_pos: Vector2 = position + Vector2(dir * gameboard.tile_set.tile_size.x * gameboard.transform.get_scale().x)
	grid_position += dir
	
	move_tween = create_tween()
	move_tween.tween_property(self, "position", new_pos, speed).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	
	if type == TILE_TYPE.YELLOW or (type == TILE_TYPE.BLUE and flavour == FLAVOURS.ORANGE):
		next_move = -dir
	
	if type == TILE_TYPE.ORANGE:
		flavour = FLAVOURS.ORANGE
	elif type == TILE_TYPE.PURPLE:
		flavour = FLAVOURS.LEMON
		next_move = dir
	
	print(TILE_TYPE.keys()[type], grid_position)	
