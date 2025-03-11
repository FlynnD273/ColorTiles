extends Button


func _ready() -> void:
  print(get_tree().root.get_children())


func _on_pressed() -> void:
  var game_manager = $"/root/GameManager"
  game_manager.tile_seed = int($"../SeedEntry".text)
  game_manager.start_game()
