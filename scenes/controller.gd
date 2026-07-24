extends Node

const SAVE_FILE = "user://save_data.json"

const loading_scene = preload("res://scenes/ui scenes/Loading.tscn")
var current_scene : PackedScene = null
var current_instance: Node = null
@onready var loadscreen_instance = loading_scene.instantiate()

func _ready() -> void:
	_transition_scene(SceneType.MAIN)
	
	if not FileAccess.file_exists(SAVE_FILE):
		var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
		file.store_string('{"progress": 1, "playthrough": 1}')
		file.close()


enum MainSceneAction {
	START = 0,
	LEVEL_SELECT = 1,
	CREDITS = 2
}
func _main_scene_action(type: MainSceneAction):
	match type:
		MainSceneAction.START:
			_transition_scene(SceneType.GAME, 1)
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
	
	
enum SceneType {
	MAIN,
	LEVEL_SELECT,
	GAME,
}
func _transition_scene(to: SceneType, level: int = 0):
	if current_instance != null:
		current_instance.queue_free()
	add_child(loadscreen_instance)
	
	match to:
		SceneType.MAIN:
			current_scene = load("res://scenes/ui scenes/main_screen/MainScreen.tscn")
			current_instance = current_scene.instantiate()
			current_instance.main_screen_action.connect(_main_scene_action)
			
		SceneType.LEVEL_SELECT:
			current_scene = load("res://scenes/ui scenes/level_select/level_select.tscn")
			current_instance = current_scene.instantiate()
			if level > 0 and level <= 8:
				current_instance.current = level
			else:
				current_instance.level_select_action.connect(_level_select_action)
		
		SceneType.GAME:
			current_scene = load("res://scenes/game/game.tscn")
			current_instance = current_scene.instantiate()
			current_instance.level = level
			current_instance.quit.connect(_quit_game)
			current_instance.update_level.connect(_update_level)

	remove_child(loadscreen_instance)
	add_child(current_instance)


func _quit_game():
	_transition_scene(SceneType.MAIN)


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
	
	_transition_scene(SceneType.LEVEL_SELECT, playthrough)
	
	if playthrough <= 8:
		await get_tree().create_timer(0.2).timeout
		_transition_scene(SceneType.GAME, playthrough)
