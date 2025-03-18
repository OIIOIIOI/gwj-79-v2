extends Area2D
class_name Drawer


var is_open := false


@onready var item_sprite: Sprite2D = $Visuals/Item
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func assign_item(item: MemoryItem) -> void:
	item_sprite.texture = item.sprite


func toggle() -> void:
	if is_open:
		animation_player.play_backwards(&"open")
	else:
		animation_player.play(&"open")


func set_is_open(value: bool) -> void:
	is_open = value
