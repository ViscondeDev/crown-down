@icon("res://addons/at-icons/node/brain.svg")
class_name Game
extends Node

signal progress_changed
signal scene_loaded

enum State {
	MAIN_MENU,
	LOADING,
	GAMEPLAY,
}

static var current: Game

var current_state: State
var scene_path: StringName
var use_sub_threads: bool = true
var progress: Array
var loaded_resource: PackedScene
var _loading_screen: PackedScene = preload("uid://hh3bqibkmsbh")


func _ready():
	set_process(false)
	current = self
	var loading_screen: LoadingScreen = _loading_screen.instantiate()
	loading_screen.screen_ready.connect(start_process)
	scene_loaded.connect(loading_screen.fade_out)
	add_child(loading_screen)


func _process(_delta: float) -> void:
	var load_status = ResourceLoader.load_threaded_get_status(scene_file_path, progress)
	progress_changed.emit(progress[0])
	match load_status:
		ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			set_process(false)
		ResourceLoader.THREAD_LOAD_LOADED:
			loaded_resource = ResourceLoader.load_threaded_get(scene_path)
			scene_loaded.emit()


func start_process():
	var state = ResourceLoader.load_threaded_request(scene_path, "", use_sub_threads)
	if state == OK:
		set_process(true)
