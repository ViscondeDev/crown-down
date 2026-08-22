@icon("res://addons/at-icons/control/hourglass.svg")
class_name LoadingScreen
extends CanvasLayer

signal screen_ready
signal screen_over

@export var animation: AnimationPlayer


func _ready() -> void:
	animation.play("fade")
	await animation.animation_finished
	screen_ready.emit()


func fade_out():
	animation.play_backwards("fade")
	await animation.animation_finished
	screen_over.emit()
