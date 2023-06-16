extends Node

const win_scene = preload("res://game/win.tscn")
const game_scene = preload("res://game/main.tscn")
const title_scene = preload("res://game/title.tscn")

var tile_seed: int = 0


func _set_win_text() -> void:
	$"../Title/TitleLabel".text = "You win!"
	$"../Title/StartButton".text = " Restart  "


func player_win() -> void:
	get_tree().change_scene_to_packed(title_scene)
	call_deferred("_set_win_text")


func load_title() -> void:
	get_tree().change_scene_to_packed(title_scene)


func start_game() -> void:
	get_tree().change_scene_to_packed(game_scene)
