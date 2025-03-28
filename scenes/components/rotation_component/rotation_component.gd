extends Node
class_name RotationComponent


@export_range(0.0, 360.0) var amount := 15.0
@export_enum("Once", "Continuous") var mode: String = "Once"


func _ready() -> void:
	if !(get_parent() is Node3D) && !(get_parent() is Node2D):
		queue_free()

	await get_parent().ready

	if mode == "Once":
		var a = randf_range(-amount, amount)
		if get_parent() is Node3D:
			if get_parent() is Sprite3D:
				match (get_parent() as Sprite3D).axis:
					Vector3.AXIS_Y:
						get_parent().rotate_object_local(Vector3.UP, deg_to_rad(a))
					_: # Default Z-Axis
						get_parent().rotate_object_local(Vector3.FORWARD, deg_to_rad(a))
			else:
				get_parent().rotate_object_local(Vector3.FORWARD, deg_to_rad(a))
		elif get_parent() is Node2D:
			get_parent().rotate(deg_to_rad(a))


func _physics_process(delta: float) -> void:
	if mode == "Continuous":
		if get_parent() is Node3D:
			get_parent().rotate_object_local(Vector3.FORWARD, amount * delta)
		elif get_parent() is Node2D:
			get_parent().rotate(deg_to_rad(amount * delta))
