extends Control


func _on_start_pressed() -> void:
	%SfxUiGmtk26Click.play()
	AudioManager.current.menu.stop()
	AudioManager.current.gameplay.trigger()
	Game.current.load_scene("uid://c0b31uun0prgp")


func _on_level_select_pressed() -> void:
	%SfxUiGmtk26Click.play()
	Game.current.load_scene("uid://bvrc1ordodcvm")


func _on_credits_pressed() -> void:
	%SfxUiGmtk26Click.play()
	Game.current.load_scene("uid://yaapxtil2i1k")
