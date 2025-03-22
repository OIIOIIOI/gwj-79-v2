extends Node2D
class_name Hand


@onready var hand_move: Sprite2D = $HandMove
@onready var hand_pull: Sprite2D = $HandPull


func _ready() -> void:
	switch_hand()


func switch_hand(move: bool = true) -> void:
	hand_move.visible = move
	hand_pull.visible = !move
