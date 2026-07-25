@icon("res://addons/at-icons/mesh/die.svg")

class_name AdaptativeSound
extends RandomSound

@onready var knight_sound: RandomSound = $Knight
@onready var bishop_sound: RandomSound = $Bishop
@onready var rook_sound: RandomSound = $Rook

@onready var audio_type := {
	Selection.KNIGHT: knight_sound,
	Selection.BISHOP: bishop_sound,
	Selection.ROOK: rook_sound,
}

enum Selection {
	KNIGHT = 0,
	BISHOP = 1,
	ROOK = 2,
}


func play():
	randomize()
	var play_as = audio_type[Level.current.pawn.current_selection]
	play_as.sounds[randi() % play_as.sounds.size()].play()
