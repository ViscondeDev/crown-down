extends Control

const SAVE_FILE = "user://save_data.json"

@export var current: int = 0 
@onready var level_buttons: Array[Button] = [
	$GridContainer/Level1,
	$GridContainer/Level2,
	$GridContainer/Level3,
	$GridContainer/Level4,
	$GridContainer/Level5,
	$GridContainer/Level6,
	$GridContainer/Level7,
	$GridContainer/Level8,
]

func _ready() -> void:
	if current > 0:
		$Back.hide()
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	var progress = JSON.parse_string(file.get_as_text())["progress"]
		
	for i in range(1, len(level_buttons) + 1):
		level_buttons[i - 1].disabled = i > progress

enum LevelAction {
	BACK = 0,
	LEVEL_SELECT = 1,
}
signal level_select_action(action: LevelAction, extra)

func _on_back_pressed() -> void:
	level_select_action.emit(LevelAction.BACK, 0)

func _on_level_select(level: int) -> void:
	level_select_action.emit(LevelAction.LEVEL_SELECT, level)

func _on_click():
	%SfxUiGmtk26Click.play()