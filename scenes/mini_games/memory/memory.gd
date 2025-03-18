extends Node2D
class_name Memory


@export var items: Array[MemoryItem] = []
@export var drawers: Array[Drawer] = []


const HAND_SPEED := 10.0


@onready var hand: Node2D = $Hand


func _ready() -> void:
	assign_items()


func assign_items() -> void:
	var unused_drawers = drawers.duplicate()
	var unused_items = items.duplicate()

	unused_drawers.shuffle()
	unused_items.shuffle()

	while unused_drawers.size() > 0 && unused_items.size() > 0:
		var item: MemoryItem = unused_items.pop_back()
		for i in 2:
			var drawer: Drawer = unused_drawers.pop_back()
			drawer.assign_item(item)


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	var camera = get_viewport().get_camera_2d()
	var mouse_position = camera.get_global_mouse_position()
	hand.global_position = hand.global_position.lerp(mouse_position, 1.0 - exp(-delta * HAND_SPEED))
