@icon("res://addons/at-icons/node/node_graph.svg")
class_name Game
extends Node

signal progress_changed(value: float)
signal scene_loaded

enum State {
	LOADING,
	PROCESS,
}

const SCENE_PATHS = {
	"menus": {
		"main": "uid://cueqp5kvayvsf",
		"level_selection": "uid://bvrc1ordodcvm",
		"credits": "uid://yaapxtil2i1k",
	},
	"levels": { 1: "uid://c0b31uun0prgp", 2: "uid://cd7127kqu8704", 3: "uid://b8f32pph3xwk5" },
}

static var current: Game

@export var main_scene: String

var current_state: State
var current_scene: Node

# Scene Loading parameters
var _use_sub_threads: bool = true
var _loading_path: String = ""
var _loading_progress: Array
var _loading_screen: PackedScene = preload("uid://hh3bqibkmsbh")


func _ready():
	current = self
	load_scene(main_scene)


func _process(_delta: float) -> void:
	if _loading_path.length() > 0:
		_check_loading_state()


func load_scene(scene_path: String) -> void:
	var loading_screen: LoadingScreen = _loading_screen.instantiate()
	scene_loaded.connect(loading_screen.fade_out)
	progress_changed.connect(loading_screen.update_progress)
	add_child(loading_screen)
	await loading_screen.screen_ready

	var state = ResourceLoader.load_threaded_request(scene_path, "", _use_sub_threads)
	if state == OK:
		_loading_path = scene_path
		current_state = State.LOADING


func _check_loading_state():
	var load_status = ResourceLoader.load_threaded_get_status(_loading_path, _loading_progress)
	progress_changed.emit(_loading_progress[0])
	match load_status:
		ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			_loading_path = ""
			printerr("BROKE AT SCENE LOADING")
		ResourceLoader.THREAD_LOAD_LOADED:
			var new_scene = ResourceLoader.load_threaded_get(_loading_path).instantiate()
			_switch_scenes(new_scene)
			_loading_path = ""


func _switch_scenes(new_scene: Node):
	if current_scene != null:
		current_scene.queue_free()
	add_child(new_scene)
	current_scene = new_scene
	current_state = State.PROCESS
	scene_loaded.emit()
