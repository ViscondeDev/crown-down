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
@onready var power_selections: Array[Button] = [%Knight, %Bishop, %Rook]

@onready var world: Node = %World

var loaded_scene: PackedScene = null
var current_instance: Node = null


func _ready() -> void:
	_load_level(level)
	%Particles.preprocess = 10

	for i in range(len(power_selections)):
		power_selections[i].disabled = false


func _load_level(to_load: int):
	if current_instance != null:
		current_instance.queue_free()
		loaded_scene = null
		await get_tree().create_timer(0.5).timeout

	match to_load:
		1:
			loaded_scene = load("uid://c0b31uun0prgp")
			%Intro.play("intro")
		2:
			loaded_scene = load("uid://cd7127kqu8704")
		3:
			loaded_scene = load("uid://b8f32pph3xwk5")
		4:
			loaded_scene = load("uid://dcb5hm4vlwxrt")
		5:
			loaded_scene = load("uid://gp4a7dg5qnbj")
		6:
			loaded_scene = load("uid://cxuu682y8u0u5")
		7:
			loaded_scene = load("uid://bhpmy0u7c80t7")
		8:
			loaded_scene = load("uid://ct16xoac3u10i")

	if loaded_scene == null:
		level_page.emit()
	else:
		current_instance = loaded_scene.instantiate()
		current_instance.state_changed.connect(_update_state)
		current_instance.update_selection.connect(_update_selection)
		current_instance.crowns_changed.connect(%Crowns.update)
		current_instance.kill.connect(_on_ai_death)

		world.add_child(current_instance)
		Level.current.update_selection.emit(Selection.ROOK, SelectionState.NONE)


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
