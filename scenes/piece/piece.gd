@icon("res://addons/at-icons/node2d/chess_pawn.svg")
class_name Piece
extends Node2D

@export var movement_type: Movement
@export var is_friendly: bool = false

var current_board_position: Vector2i
var possible_moves: Array[Vector2i]

@onready var movement_animation: PieceMovement = %PieceMovement
@onready var sprite: Sprite2D = %Sprite2D
@onready var death_sound: Node = %Death
@onready var move_sound: Node = %Move
@onready var landing_sound: Node = %Landing
@onready var attack_sound: Node = %Attack


func _ready():
	if movement_type != null:
		sprite.frame = movement_type.sprite_frame
	current_board_position = Board.current_board.local_to_map(global_position)
	Board.current_board.pieces[current_board_position] = self


func move_to_tile(tile: Vector2i) -> void:
	if tile in possible_moves:
		if not is_friendly:
			Board.effects_layer.highlight_tiles(
				possible_moves,
				Board.effects_layer.Effect.THRETENED,
			)

		move_sound.play()

		sprite.frame_coords.y += 1
		movement_animation.queue_movement(
			Board.current_board.map_to_local(current_board_position),
			Board.current_board.map_to_local(tile),
		)
		await movement_animation.movement_finished

		sprite.frame_coords.y -= 1
		if (
			tile in Board.current_board.pieces.keys()
			and Board.current_board.pieces[tile].is_friendly != is_friendly
		):
			attack_sound.play()
			Board.current_board.pieces[tile].get_taken()

		landing_sound.play()
		Board.current_board.pieces.erase(current_board_position)
		current_board_position = tile
		Board.current_board.pieces[tile] = self
		Board.effects_layer.clear()
		Level.current.finish_turn()
	else:
		push_warning(name, " tried to move to invalid tile.")


func get_taken() -> void:
	if is_friendly:
		Level.current.end_game(Level.State.LOST)
	elif Board.current_board.pieces.size() == 2:
		Level.current.end_game(Level.State.WON)
	Board.current_board.pieces.erase(current_board_position)
	death_sound.play()
	visible = false
