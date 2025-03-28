extends Node
class_name WaveComponent


@export var sprite: Sprite3D


func _ready() -> void:
	if sprite == null:
		return

	sprite.rotation_degrees.z = 0.0
	sprite.scale = Vector3.ONE

	await get_tree().create_timer(randf_range(0.0, 3.2)).timeout

	var scale_tween = create_tween()
	scale_tween.set_loops()
	scale_tween.tween_property(sprite, ^"scale", Vector3(0.98, 1.02, 1.0), 1.6)
	scale_tween.tween_property(sprite, ^"scale", Vector3(1.02, 0.98, 1.0), 1.6)

	var rotation_tween = create_tween()
	rotation_tween.set_loops()
	rotation_tween.set_trans(Tween.TRANS_CUBIC)
	rotation_tween.tween_property(sprite, ^"rotation_degrees", Vector3(0.0, 0.0, 2.0), 1.6).set_delay(0.8)
	rotation_tween.tween_property(sprite, ^"rotation_degrees", Vector3(0.0, 0.0, -2.0), 1.6)
