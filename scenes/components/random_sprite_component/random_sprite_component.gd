extends Sprite3D
class_name RandomSpriteComponent


enum AnchorPosition {
	Center,
	BottomCenter,
}


@export var sprites: Array[Texture2D] = []
@export var anchor: AnchorPosition


func _ready() -> void:
	texture = sprites.pick_random()

	if anchor == AnchorPosition.Center:
		centered = true
	elif anchor == AnchorPosition.BottomCenter:
		centered = false
		offset.x = texture.get_size().x * -0.5
