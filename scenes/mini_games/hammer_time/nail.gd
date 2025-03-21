extends Sprite2D
class_name Nail


var hits_received := 0
var required_hits := 4
var nail_height := 472.0


@onready var nail_sprite: Sprite2D = $NailSprite


func _ready() -> void:
	nail_sprite.position.y = 0.0


func hit() -> void:
	if hits_received >= required_hits:
		return

	hits_received += 1
	nail_sprite.position.y = nail_height / float(required_hits) * float(hits_received)
