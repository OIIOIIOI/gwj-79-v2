extends Node
class_name RotationComponent


@export_range(0.0, 180.0) var amount := 15.0


func _ready() -> void:
	await get_parent().ready

	var a = randf_range(-amount, amount)

	if get_parent() is Node3D:
		get_parent().rotate_object_local(Vector3.FORWARD, deg_to_rad(a))
	elif get_parent() is Node2D:
		get_parent().rotate(deg_to_rad(a))
	else:
		queue_free()
