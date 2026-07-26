extends Label

@onready var animation: AnimationPlayer = $AnimationPlayer

var crowns: int


func update(count: int):
	if crowns != count:
		text = str(count)
		crowns = count
		animation.play("count")
