extends Label

@onready var animation:AnimationPlayer = $AnimationPlayer

func update(count:int):
	text = str(count)
	animation.play("count")