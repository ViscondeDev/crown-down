extends Node

@onready var sounds = get_children()


func _on_hover():
	randomize()
	sounds[randi() % sounds.size()].play()
