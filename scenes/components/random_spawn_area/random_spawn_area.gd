extends Area3D
class_name RandomSpawnArea


@export var spawn_area: CollisionShape3D
@export var count: int = 10
@export var randomize_y: bool = false
@export var objects: Array[PackedScene] = []


func _ready() -> void:
	monitorable = false
	monitoring = false
	collision_layer = 0
	collision_mask = 0

	if objects.size() == 0 || spawn_area == null || !spawn_area.shape is BoxShape3D:
		return

	spawn_area.disabled = true

	var spawn_shape: BoxShape3D = spawn_area.shape as BoxShape3D
	var min_position: Vector3 = spawn_area.position - spawn_shape.size * 0.5
	var max_position: Vector3 = spawn_area.position + spawn_shape.size * 0.5

	var spawn_position := Vector3.ZERO
	var object: PackedScene
	var instance: Node3D

	for i in count:
		spawn_position.x = randf_range(min_position.x, max_position.x)
		spawn_position.z = randf_range(min_position.z, max_position.z)
		if randomize_y:
			spawn_position.y = randf_range(min_position.y, max_position.y)

		object = objects.pick_random() as PackedScene
		instance = object.instantiate() as Node3D
		add_child(instance)
		instance.position = spawn_position
