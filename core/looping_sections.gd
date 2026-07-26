@icon("res://addons/at-icons/mesh/arrows_clockwise.svg")
class_name LoopingMusic
extends Node

@export var intro: AudioStreamPlayer
@export var intro_tail: AudioStreamPlayer
@export var loop: AudioStreamPlayer
@export var loop_tail: AudioStreamPlayer


func _ready() -> void:
	intro.finished.connect(_start_loop)
	loop.finished.connect(_loop_again)


func trigger() -> void:
	AudioManager.current.transition.play()
	if intro != null:
		intro.play()


func stop() -> void:
	intro.stop()
	loop.stop()


func _start_loop():
	intro_tail.play()
	loop.play()


func _loop_again():
	loop_tail.play()
	loop.play()
