@icon("res://addons/at-icons/node2d/chess_pawn.svg")
class_name Piece
extends Node2D

@export var movement_type: Movement
@export var is_friendly: bool = false

var current_board_position: Vector2i
var possible_moves: Array[Vector2i]

@onready var movement_animation: PieceMovement = %PieceMovement
@onready var sprite: Sprite2D = %Sprite2D


func _ready():
	if movement_type != null:
		sprite.frame = movement_type.sprite_frame
	current_board_position = Board.current_board.local_to_map(global_position)
	Board.current_board.pieces[current_board_position] = self


func move_to_tile(tile: Vector2i) -> void:
	if tile in possible_moves:
		if (
			tile in Board.current_board.pieces.keys()
			and Board.current_board.pieces[tile].is_friendly != is_friendly
		):
			Board.current_board.pieces[tile].get_taken()

		movement_animation.queue_movement(
			Board.current_board.map_to_local(current_board_position),
			Board.current_board.map_to_local(tile),
		)
		await movement_animation.movement_finished

		Board.current_board.pieces.erase(current_board_position)
		current_board_position = tile
		Board.current_board.pieces[tile] = self
		Level.current.finish_turn()
	else:
		push_warning(name, " tried to move to invalid tile.")


func get_taken() -> void:
	if is_friendly:
		Level.current.end_game(Level.State.LOST)
	Board.current_board.pieces.erase(current_board_position)
	if Board.current_board.pieces.size() == 1:
		Level.current.end_game(Level.State.WON)
	queue_free()
