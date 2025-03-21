extends Node2D
class_name Nail


var hits_received := 0
var required_hits := 4
var nail_height := 472.0


@onready var nail_mask: Sprite2D = $NailMask
@onready var nail_sprite: Sprite2D = $NailMask/NailSprite
@onready var go_down_timer: Timer = $GoDownTimer


func _ready() -> void:
	nail_sprite.position.y = 0.0

	go_down_timer.timeout.connect(on_go_down_timer_timeout)


func hit() -> float:
	hits_received = min(hits_received + 1, required_hits)
	go_down_timer.start(0.2)

	return float(hits_received) / float(required_hits)


func on_go_down_timer_timeout() -> void:
	nail_sprite.position.y = nail_height / float(required_hits) * float(hits_received)


func fall() -> void:
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(nail_mask, ^"rotation_degrees", 90.0, 0.5)
	tween.tween_property(self, ^"modulate", Color.TRANSPARENT, 0.5).set_delay(1.0)

	await tween.finished
	queue_free()
