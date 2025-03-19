extends Area2D
class_name Drawer


@export var up_drawer: Drawer
@export var right_drawer: Drawer
@export var down_drawer: Drawer
@export var left_drawer: Drawer


var is_open := false
var is_gone := false


@onready var item_sprite: Sprite2D = $Visuals/Item
@onready var front_sprite: Sprite2D = $Visuals/Front
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func assign_item(item: MemoryItem) -> void:
	item_sprite.texture = item.sprite


func highlight(active: bool = true) -> void:
	front_sprite.modulate = Color.PINK if active else Color.WHITE


func toggle() -> void:
	if is_open:
		animation_player.play_backwards(&"open")
	else:
		animation_player.play(&"open")


func set_is_open(value: bool) -> void:
	is_open = value
