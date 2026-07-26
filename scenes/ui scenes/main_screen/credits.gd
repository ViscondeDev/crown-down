extends CanvasLayer

@onready var back_button: Button = $Back
@onready var texts: Array[Label] = [$CreditTitle, $Names, $Does]
@onready var screen_cover = %ScreenCover
@onready var loading_text = %LoadingText
@onready var credit_screen = %Credits


func _ready() -> void:
	set_alpha(0.0)


func set_alpha(alpha: float):
	for t in texts:
		var color = t.get_theme_color("font_color")
		color.a = alpha
		t.add_theme_color_override("font_color", color)
	back_button.modulate.a = alpha


func _on_back_pressed() -> void:
	%SfxUiGmtk26BackDeclineButton.play()
	var tween = create_tween()
	tween.tween_method(credit_screen.set_alpha, 1.0, 0.0, 0.1)
	tween.tween_method(_cover_fade, 1.0, 0.0, 0.1)
	tween.tween_callback(screen_cover.hide)
	tween.parallel().tween_callback(credit_screen.hide)


func _cover_fade(val: float):
	screen_cover.color.a = val
