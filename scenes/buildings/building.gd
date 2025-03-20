extends StaticBody3D
class_name Building


@export var side_material: StandardMaterial3D = preload("res://assets/sprites/buildings/side/side_mat.tres")


@onready var front: MeshInstance3D = $Front
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D


func _ready() -> void:
	var mesh := front.mesh as QuadMesh

	resize_collision_shape(mesh.size)

	if side_material:
		add_sides(mesh.size)


func resize_collision_shape(front_size: Vector2) -> void:
	var shape := collision_shape_3d.shape as BoxShape3D
	shape.size.x = front_size.x
	shape.size.y = front_size.y
	if side_material:
		shape.size.z = get_side_size(front_size).x

	collision_shape_3d.position = Vector3(front.position.x, front.position.y, front.position.z - shape.size.z * 0.5)


func add_sides(front_size: Vector2) -> void:
	var side_size := get_side_size(front_size)
	var side_mesh := QuadMesh.new()
	side_mesh.size = side_size
	side_mesh.material = side_material

	var left_side := MeshInstance3D.new()
	left_side.mesh = side_mesh
	left_side.rotate_y(deg_to_rad(-90))
	left_side.position.x = front.position.x - front_size.x * 0.5
	left_side.position.y = front.position.y
	left_side.position.z = front.position.z - side_size.x * 0.5

	var right_side := MeshInstance3D.new()
	right_side.mesh = side_mesh
	right_side.rotate_y(deg_to_rad(90))
	right_side.position.x = front.position.x + front_size.x * 0.5
	right_side.position.y = front.position.y
	right_side.position.z = front.position.z - side_size.x * 0.5

	add_child(left_side)
	add_child(right_side)


func get_side_size(front_size: Vector2) -> Vector2:
	var texture_size := side_material.albedo_texture.get_size()
	return Vector2(front_size.y * texture_size.x / texture_size.y, front_size.y)
