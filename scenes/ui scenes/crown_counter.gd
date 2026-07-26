extends Label

@onready var animation: AnimationPlayer = $AnimationPlayer

var crowns: int


func update(count: int):
	print("called to count crown down")
	if crowns != count:
		text = str(count)
		crowns = count
		animation.play("count")
