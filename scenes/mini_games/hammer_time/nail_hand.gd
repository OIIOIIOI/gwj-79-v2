extends Node2D
class_name NailHand


@onready var nail_sprite: Sprite2D = $NailSprite
@onready var hand_sprite: Sprite2D = $HandSprite
@onready var star_sprite: Sprite2D = $StarSprite


func _ready() -> void:
	star_sprite.visible = false


func show_nail() -> void:
	nail_sprite.visible = true


func hide_nail() -> void:
	nail_sprite.visible = false


func hit() -> void:
	star_sprite.visible = true

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(hand_sprite, ^"modulate", Color(1.0, 0.5, 0.5), 0.1)
	tween.tween_callback(func(): star_sprite.visible = false)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(hand_sprite, ^"modulate", Color.WHITE, 0.3)
