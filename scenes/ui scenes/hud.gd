@icon("res://addons/at-icons/control/desktop.svg")
class_name HUD
extends CanvasLayer

signal quit()
signal restart()

@onready var prompt: Label = %Prompt
@onready var intro: AnimationPlayer = %Intro
@onready var pause_screen: ColorRect = %PauseScreen
@onready var crown_animation: AnimationPlayer = %CrownAnimation
@onready var crown_counter: Label = %CrownConter


func update(count: int):
	if crown_counter.text != str(count):
		crown_counter.text = str(count)
		crown_counter.text = str(count)
		crown_animation.play("count")


func _on_piece_pressed(extra_arg_0: int) -> void:
	pass # Replace with function body.


func _on_pause_pressed() -> void:
	pass # Replace with function body.


func _on_resume_pressed() -> void:
	get_tree().paused = false
	hide()


func _on_quit_pressed() -> void:
	get_tree().paused = false
	hide()
	quit.emit()


func _on_restart_level_pressed() -> void:
	get_tree().paused = false
	hide()
	restart.emit()
