extends Node

const SAVE_FILE = "user://save_data.json"

var current_scene : PackedScene = null
var current_instance: Node = null

@onready var scene = $Scene
@onready var screen_cover = %ScreenCover
@onready var loading_text = %LoadingText

func _ready() -> void:
	_transition_scene(SceneType.MAIN)

	if not FileAccess.file_exists(SAVE_FILE):
		var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
		file.store_string('{"progress": 1, "playthrough": 1}')
		file.close()
	AudioManager.current.menu.trigger()
	print("instaciated")


enum MainSceneAction {
	START = 0,
	LEVEL_SELECT = 1,
	CREDITS = 2
}
func _main_scene_action(type: MainSceneAction):
	match type:
		MainSceneAction.START:
			_transition_scene(SceneType.GAME, 1)
			AudioManager.current.menu.stop()
			AudioManager.current.gameplay.trigger()
		MainSceneAction.LEVEL_SELECT:
			_transition_scene(SceneType.LEVEL_SELECT)
		MainSceneAction.CREDITS:
			print("Credits not created yet")


enum LevelActionAction {
	BACK = 0,
	LEVEL_SELECT = 1,
}
func _level_select_action(type: LevelActionAction, extra):
	match type:
		LevelActionAction.BACK:
			_transition_scene(SceneType.MAIN)
		LevelActionAction.LEVEL_SELECT:
			_transition_scene(SceneType.GAME, extra)
			AudioManager.current.menu.stop()
			AudioManager.current.gameplay.trigger()


enum SceneType {
	MAIN,
	LEVEL_SELECT,
	GAME,
}
func _transition_scene(to: SceneType, level: int = 0):
	screen_cover.show()
	loading_text.show()
	
	var tween = create_tween()
	tween.tween_method(_cover_fade, 0.0, 1.0, 0.05)
	tween.tween_method(_text_fade, 0.0, 1.0, 0.15)

	if current_instance != null:
		tween.tween_callback(current_instance.queue_free)

	tween.tween_callback(_switch_scene.bind(to, level))


func _switch_scene(to: SceneType, level: int):
	match to:
		SceneType.MAIN:
			current_scene = load("res://scenes/ui scenes/main_screen/MainScreen.tscn")
			current_instance = current_scene.instantiate()
			current_instance.main_screen_action.connect(_main_scene_action)

		SceneType.LEVEL_SELECT:
			current_scene = load("res://scenes/ui scenes/level_select/level_select.tscn")
			current_instance = current_scene.instantiate()
			current_instance.level_select_action.connect(_level_select_action)

		SceneType.GAME:
			current_scene = load("res://scenes/game/game.tscn")
			current_instance = current_scene.instantiate()
			current_instance.level = level
			current_instance.update_level.connect(_update_level)
			current_instance.quit.connect(_transition_scene.bind(SceneType.MAIN))
			current_instance.level_page.connect(_transition_scene.bind(SceneType.LEVEL_SELECT))

	scene.add_child(current_instance)
	var tween = create_tween()
	tween.tween_method(_text_fade, 1.0, 0.0, 0.15)
	tween.parallel().tween_method(_cover_fade, 1.0, 0.0, 0.15)
	tween.tween_callback(screen_cover.hide)
	tween.tween_callback(loading_text.hide)


func _cover_fade(val: float):
	screen_cover.color.a = val


func _text_fade(val: float):
	var color: Color = loading_text.get_theme_color("font_color")
	color.a = val
	loading_text.add_theme_color_override("font_color", color)


func _update_level(level: int):
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	var obj = JSON.parse_string(file.get_as_text())
	obj["playthrough"] = level
	obj["progress"] = level if obj["progress"] < level else obj["progress"]
	file.close()
	var playthrough = obj["playthrough"]

	file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file.store_string(JSON.stringify(obj))
	file.close()

	if playthrough <= 8:
		_transition_scene(SceneType.GAME, playthrough)
	else:
		_transition_scene(SceneType.LEVEL_SELECT)
