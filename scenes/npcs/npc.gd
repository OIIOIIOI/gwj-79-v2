extends StaticBody3D
class_name NPC


@export var sprites: Array[Texture2D] = []


@onready var sprite: Sprite3D = $Sprite3D


func _ready() -> void:
	pick_random_sprite(true)


func pick_random_sprite(force: bool = false) -> void:
	if sprites.size() == 0:
		return

	var r = randi() % 3
	if force || r == 0:
		sprite.texture = sprites.pick_random()

	await get_tree().create_timer(randf_range(1.0, 3.0)).timeout
	pick_random_sprite()
