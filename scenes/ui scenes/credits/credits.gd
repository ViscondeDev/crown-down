extends Control


func _on_back_pressed() -> void:
	%SfxUiGmtk26BackDeclineButton.play()
	Game.current.load_scene(Game.SCENE_PATHS.menus.main)
