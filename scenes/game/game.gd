extends Node

signal quit()
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

const LOADING_SCENE = preload("res://scenes/ui scenes/Loading.tscn")
@export var level: int = 0
@onready var loadscreen_instance = LOADING_SCENE.instantiate()
@onready var power_selections: Array[Button] = [%Knight, %Bishop, %Rook]

@onready var world: Node = %World

var loaded_scene: PackedScene = null
var current_instance: Node = null


func _ready() -> void:
	_load_level(level)

	for i in range(len(power_selections)):
		power_selections[i].disabled = false


func _load_level(to_load: int):
	if current_instance != null:
		current_instance.queue_free()
		await get_tree().create_timer(0.5).timeout
	add_child(loadscreen_instance)
	match to_load:
		1:
			loaded_scene = load("res://scenes/levels/level1.tscn")
		2:
			loaded_scene = load("res://scenes/levels/level3.tscn")
		3:
			loaded_scene = load("res://scenes/levels/level2.tscn")

	current_instance = loaded_scene.instantiate()
	current_instance.state_changed.connect(_update_state)
	current_instance.update_selection.connect(_update_selection)

	remove_child(loadscreen_instance)
	world.add_child(current_instance)
	Level.current.update_selection.emit(Selection.ROOK, SelectionState.NONE)


func _update_state(new_state: GameState):
	match new_state:
		GameState.WON:
			Board.current_board.pieces.clear()
			update_level.emit(level + 1)
		GameState.LOST:
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


func _on_pause_pressed() -> void:
	get_tree().paused = true
	%PauseScreen.show()


func _on_pause_screen_quit() -> void:
	quit.emit()


func _on_pause_screen_restart() -> void:
	_load_level(level)
