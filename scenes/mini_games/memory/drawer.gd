extends Node2D
class_name Drawer


@export var up_drawer: Drawer
@export var right_drawer: Drawer
@export var down_drawer: Drawer
@export var left_drawer: Drawer


var item: MemoryItem
var is_open := false
var is_gone := false


@onready var item_sprite: Sprite2D = $Visuals/Item
@onready var front_sprite: Sprite2D = $Visuals/Front
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hand_target: Marker2D = %HandTarget


func assign_item(memory_item: MemoryItem) -> void:
	item = memory_item
	item_sprite.texture = item.sprite


func highlight(active: bool = true) -> void:
	front_sprite.modulate = Color.PINK if active else Color.WHITE


func open() -> void:
	animation_player.play(&"open")
	await animation_player.animation_finished
	is_open = true


func close() -> void:
	animation_player.play_backwards(&"open")
	await animation_player.animation_finished
	is_open = false


func fade() -> void:
	animation_player.play(&"fade")
	await animation_player.animation_finished
	is_gone = true
