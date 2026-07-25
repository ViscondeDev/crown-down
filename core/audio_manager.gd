@icon("res://addons/at-icons/mesh/headphones.svg")
class_name AudioManager
extends Node

@export var menu: LoopingMusic
@export var gameplay: LoopingMusic

static var current: AudioManager


func _ready() -> void:
	current = self
