extends Node

signal quit()
signal level_page()
signal update_level(level: int)

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
enum GameState {
	LOADING = 0,
	SELECTION = 1,
	MOVEMENT = 2,
	ENEMY = 3,
	WON = 4,
	LOST = 5,
}

@export var level: int = 0

var loaded_scene: PackedScene = null
var current_instance: Node = null

@onready var power_selections: Array[Button] = [%Knight, %Bishop, %Rook]

@onready var world: Node = %World


func _ready() -> void:
	_load_level(level)
	%Particles.preprocess = 10

	for i in range(len(power_selections)):
		power_selections[i].disabled = false


func _update_state(new_state: GameState):
	match new_state:
		GameState.WON:
			Board.current_board.pieces.clear()
			update_level.emit(level + 1)
		GameState.LOST:
			%DeathSound.play()
			_load_level(level)


func _update_selection(_selection: Selection, state: SelectionState):
	for i in range(len(power_selections)):
		match state:
			SelectionState.SELECTED:
				power_selections[i].disabled = true
			SelectionState.NONE:
				power_selections[i].disabled = false


func _select(selection: Selection):
	Level.current.update_selection.emit(selection, SelectionState.SELECTED)
	match selection:
		Selection.BISHOP:
			%SfxUiGmtk26ChooseBishopButton.play()
		Selection.KNIGHT:
			%SfxUiGmtk26ChooseKnightButton.play()
		Selection.ROOK:
			%SfxUiGmtk26ChooseRookButton.play()


func _on_pause_pressed() -> void:
	get_tree().paused = true
	%PauseScreen.show()


func _on_pause_screen_quit() -> void:
	AudioManager.current.gameplay.stop()
	AudioManager.current.menu.trigger()
	quit.emit()


func _on_pause_screen_restart() -> void:
	_load_level(level)


func _on_click():
	%SfxUiGmtk26Click.play()


func _on_ai_death():
	%AIDeath.play()
