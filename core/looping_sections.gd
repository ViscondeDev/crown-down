@icon("res://addons/at-icons/mesh/arrows_clockwise.svg")
class_name LoopingMusic
extends Node

@export var intro: AudioStreamPlayer
@export var intro_tail: AudioStreamPlayer
@export var loop: AudioStreamPlayer
@export var loop_tail: AudioStreamPlayer
@export var play_transition: bool

var playing: bool


func _ready() -> void:
	var volume = loop.volume_db
	loop.volume_db = -80
	loop.play()
	await get_tree().create_timer(0.1).timeout
	loop.stop()
	loop.volume_db = volume

	volume = loop_tail.volume_db
	loop_tail.volume_db = -80
	loop_tail.play()
	await get_tree().create_timer(0.1).timeout
	loop_tail.stop()
	loop_tail.volume_db = volume

	volume = intro_tail.volume_db
	intro_tail.volume_db = -80
	intro_tail.play()
	await get_tree().create_timer(0.1).timeout
	intro_tail.stop()
	intro_tail.volume_db = volume

func trigger() -> void:
	if play_transition:
		AudioManager.current.transition.play()
		await get_tree().create_timer(1.8).timeout
	intro.play()
	playing = true
	await get_tree().create_timer(intro.stream.get_length()).timeout
	if playing == true:
		_start_loop()


func stop() -> void:
	intro.stop()
	loop.stop()
	playing = false


func _start_loop():
	intro_tail.play()
	loop.play()
	await get_tree().create_timer(loop.stream.get_length()).timeout
	if playing == true:
		_loop_again()


func _loop_again():
	loop_tail.play()
	loop.play()
	await get_tree().create_timer(loop.stream.get_length()).timeout
	if playing == true:
		_loop_again()
