@icon("res://addons/at-icons/mesh/arrows_clockwise.svg")
class_name LoopingMusic
extends Node

@export var intro: AudioStreamPlayer
@export var intro_tail: AudioStreamPlayer
@export var loop: AudioStreamPlayer
@export var loop_tail: AudioStreamPlayer
@export var play_transition: bool

var playing: bool


func trigger() -> void:
	if play_transition:
		AudioManager.current.transition.play()
		await get_tree().create_timer(1.8).timeout
	intro.play()
	await get_tree.create_timer(intro.stream.get_lenght())


func stop() -> void:
	intro.stop()
	loop.stop()


func _start_loop():
	intro_tail.play()
	loop.play()


func _loop_again():
	loop_tail.play()
	loop.play()
