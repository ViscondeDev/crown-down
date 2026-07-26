extends Control

enum Action {
	START = 0,
	LEVEL_SELECT = 1,
	CREDITS = 2
}
signal main_screen_action(type: Action)

func _on_start_pressed() -> void:
	main_screen_action.emit(Action.START)

func _on_level_select_pressed() -> void:
	%SfxUiGmtk26Click.play()
	main_screen_action.emit(Action.LEVEL_SELECT)

func _on_credits_pressed() -> void:
	%SfxUiGmtk26Click.play()
	main_screen_action.emit(Action.CREDITS)
