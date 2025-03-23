extends Sprite3D


func _process(delta: float) -> void:
	region_rect.position.y += delta * 12.0
