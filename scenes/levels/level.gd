@icon("res://addons/at-icons/node2d/globe.svg")
class_name Level
extends Node2D

signal state_changed(new_state: State)
signal update_selection(selection: Selection, state: SelectionState)
signal crowns_changed(crowns: int)
signal kill(crowns: int)

enum State {
	LOADING = 0,
	SELECTION = 1,
	PAWN_TURN = 2,
	ENEMY_TURN = 3,
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

var current_state: State = State.LOADING:
	set(s):
		current_state = s
		state_changed.emit(current_state)

@onready var pawn: Pawn = %Pawn
@onready var enemie_ai: EnemyAI = %EnemyAI


func _ready() -> void:
	y_sort_enabled = true
	current = self
	state_changed.connect(pawn.watch_game_state)
	state_changed.connect(enemie_ai.watch_state)
	update_selection.connect(pawn.get_selection)
	crowns_changed.emit(Board.current_board.pieces.size() - 1)
	current_state = State.SELECTION


func finish_turn() -> void:
	match current_state:
		State.PAWN_TURN:
			current_state = State.ENEMY_TURN
			crowns_changed.emit(Board.current_board.pieces.size() - 1)
		State.ENEMY_TURN:
			update_selection.emit(Selection.BISHOP, SelectionState.NONE)
			current_state = State.SELECTION


func restart_level() -> void:
	Root.current.load_scene(scene_file_path)


func end_game(state: State) -> void:
	current_state = state
