@icon("res://addons/at-icons/node2d/globe.svg")
class_name Level
extends Node2D

signal state_changed(new_state: State)
signal update_selection(selection: Selection, state: SelectionState)
signal crowns_changed(crowns: int)

enum State {
	LOADING = 0,
	SELECTION = 1,
	MOVEMENT = 2,
	ENEMY = 3,
	WON = 4,
	LOST = 5,
}
enum Selection {
	KNIGHT = 0,
	BISHOP = 1,
	ROOK = 2,
}
enum SelectionState {
	DISABLED = 0,
	SELECTED = 1,
	NONE = 2,
}

static var current: Level

@export var pawn_selection: Selection = Selection.KNIGHT
@onready var pawn: Pawn = %Pawn
@onready var enemie_ai: EnemyAI = %EnemyAI

var current_state: State = State.LOADING:
	set(s):
		current_state = s
		state_changed.emit(current_state)


func _ready() -> void:
	current = self
	state_changed.connect(pawn.watch_game_state)
	state_changed.connect(enemie_ai.watch_state)
	update_selection.connect(pawn.get_selection)
	crowns_changed.emit(Board.current_board.pieces.size() - 1)
	current_state = State.SELECTION


func finish_turn() -> void:
	match current_state:
		State.MOVEMENT:
			current_state = State.ENEMY
			crowns_changed.emit(Board.current_board.pieces.size() - 1)
		State.ENEMY:
			update_selection.emit(Selection.BISHOP, SelectionState.NONE)
			current_state = State.SELECTION


func end_game(state: State) -> void:
	current_state = state
