extends Camera2D

@export var target: Node2D
@export var smoothing: float

var is_fixed = false


func _process(delta: float) -> void:
  if not (is_fixed or get_tree().paused):
    position = position.lerp(target.position, smoothing * delta)


func _on_pause_zoom_changed(new_zoom: float) -> void:
  if new_zoom > 0:
    zoom = Vector2(new_zoom, new_zoom)
    if is_fixed:
      position = target.position
      print(position)
    is_fixed = false
  else:
    var gb = $"../Gameboard"
    var tile_size = gb.get_tile_size()
    var fit_zoom = 7.5 / gb.height
    zoom = Vector2(fit_zoom, fit_zoom)

    if not is_fixed:
      position = Vector2(gb.width * tile_size / 2, gb.height * tile_size / 2)
      print(position)
    is_fixed = true

