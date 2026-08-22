extends Control


func _ready() -> void:
	var buttons = %LevelList.get_children()
	for n in buttons.size():
		buttons[n].pressed.connect(_on_level_select.bind(n + 1))


func _on_back_pressed() -> void:
	%SfxUiGmtk26BackDeclineButton.play()
	Game.current.load_scene(Game.SCENE_PATHS.menus.main)


func _on_level_select(level: int) -> void:
	%SfxUiGmtk26Click.play()
	Game.current.load_scene(Game.SCENE_PATHS.levels[level])
