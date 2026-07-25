@icon("res://addons/at-icons/mesh/die.svg")

class_name RandomSound
extends Node

@onready var sounds = get_children()


func play():
	randomize()
	sounds[randi() % sounds.size()].play()
