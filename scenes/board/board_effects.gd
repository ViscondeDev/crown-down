@icon("res://addons/at-icons/node2d/stars.svg")
class_name BoardEffects
extends TileMapLayer

enum Effect {
	AVALIABLE,
	THRETENED,
}

var highlight_duration: float = 0.3
var effect_tiles := {
	Effect.AVALIABLE: Vector2(3, 4),
	Effect.THRETENED: Vector2(3, 5),
}


func _ready() -> void:
	Board.effects_layer = self


func highlight_tiles(tiles: Array[Vector2i], effect: Effect) -> void:
	clear()
	var time_for_tile = highlight_duration / tiles.size()
	for tile in tiles:
		set_cell(tile, 0, effect_tiles[effect])
		await get_tree().create_timer(time_for_tile).timeout
