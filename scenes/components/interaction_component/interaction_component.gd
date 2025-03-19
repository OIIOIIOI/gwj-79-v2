extends Area3D
class_name InteractionComponent


@export var condition: Condition
@export var dialog: Dialog
@export var actions: Array[Action] = []
@export var radius := 1.0


var is_in_range := false


@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D


func _ready() -> void:
	var shape = collision_shape_3d.shape as CylinderShape3D
	shape.radius = radius

	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)


func on_body_entered(body: Node3D) -> void:
	print("on_body_entered", body.name)
	if body is Player:
		is_in_range = true


func on_body_exited(body: Node3D) -> void:
	print("on_body_exited", body.name)
	if body is Player:
		is_in_range = false


func is_valid() -> bool:
	print("check validity: ", name, ": ", is_in_range)
	if condition:
		return is_in_range && condition.check()
	return is_in_range
