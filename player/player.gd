extends Node2D

@export var speed: float = 3
@export var gameboard: TileMap

const TILE_TYPE = preload("res://types/tile_type.gd").TILE_TYPE
const FLAVOURS = preload("res://types/flavours.gd").FLAVOURS

var next_move: Vector2i
var move_tween: Tween
var grid_position: Vector2i
var current_tile_type: TILE_TYPE
var flavour: FLAVOURS
var move_start: Vector2i
var start_pos: Vector2i

var TILE_WIDTH: float
var POS_OFFSET: Vector2


var inputs = {"ui_right": Vector2i.RIGHT,
			  "ui_left": Vector2i.LEFT,
			  "ui_up": Vector2i.UP,
			  "ui_down": Vector2i.DOWN}


var directions = {"ui_right": 0,
			  "ui_left": 180,
			  "ui_up": -90,
			  "ui_down": 90}


func grid_to_position(grid: Vector2i) -> Vector2:
	return Vector2(grid * TILE_WIDTH) + POS_OFFSET


func _ready() -> void:
	TILE_WIDTH = gameboard.tile_set.tile_size.x * gameboard.transform.get_scale().x
	POS_OFFSET = Vector2(TILE_WIDTH / 2.0, TILE_WIDTH / 2.0)
	process_mode = Node.PROCESS_MODE_PAUSABLE
	_reset()


func _win() -> void:
	$"/root/GameManager".player_win()
	return


func _reset() -> void:
	next_move = Vector2i.ZERO
	move_tween = null
	grid_position = start_pos
	position = grid_to_position(grid_position)
	current_tile_type = TILE_TYPE.PINK
	flavour = FLAVOURS.LEMON
	move_start = Vector2i(-1, -1)


func _process(_delta: float) -> void:
	if move_tween != null and move_tween.is_running():
		return
	
	if current_tile_type == TILE_TYPE.GREEN:
		_win()
	
	if grid_position == move_start:
		next_move = Vector2i.ZERO
		
	if next_move != Vector2i.ZERO:
		var temp_move: Vector2i = next_move
		next_move = Vector2i.ZERO
		automove(temp_move)
		return
	
	move_start = Vector2i(-1, -1)
	
	if Input.is_action_just_pressed("reset"):
		_reset()
	
	for dir in inputs.keys():
		if Input.is_action_pressed(dir):
			$Sprite2D.rotation_degrees = directions[dir]
			move(inputs[dir])
			break


func automove(dir: Vector2i) -> void:
	var type: TILE_TYPE = gameboard.get_tile_type(grid_position + dir)
	if type == TILE_TYPE.RED:
		return
		
	grid_position += dir	
	var new_pos: Vector2 = grid_to_position(grid_position)
	
	move_tween = create_tween()
	move_tween.tween_property(self, "position", new_pos, speed).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	
	if type == TILE_TYPE.YELLOW or (type == TILE_TYPE.BLUE and flavour == FLAVOURS.ORANGE):
		next_move = -dir
	
	if type == TILE_TYPE.ORANGE:
		flavour = FLAVOURS.ORANGE
	elif type == TILE_TYPE.PURPLE:
		flavour = FLAVOURS.LEMON
		next_move = dir
	
	current_tile_type = type


func move(dir: Vector2i) -> void:
	move_start = grid_position
		
	automove(dir)


func _on_pause_reset() -> void:
	_reset()


func set_start(pos: Vector2i) -> void:
	position = grid_to_position(pos)
	grid_position = pos
	start_pos = pos
