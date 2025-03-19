extends Node2D
class_name Memory


const HAND_SPEED := 10.0
const HAND_ROTATION := 15.0
enum GAME_STATE {
	Start,
	Ready,
	Moving,
	Fail,
	Success,
	End,
}


@export var items: MemoryItems

var drawers: Array[Drawer]
var hovered_drawers: Array[Drawer] = []
var opened_drawers: Array[Drawer] = []
var current_drawer: Drawer
var game_state: GAME_STATE = GAME_STATE.Start


@onready var hand: Area2D = $Hand


func _ready() -> void:
	drawers = get_all_drawers()
	assign_items()

	hand.area_entered.connect(on_hand_area_entered)
	hand.area_exited.connect(on_hand_area_exited)

	animate_start()


func get_all_drawers() -> Array[Drawer]:
	var valid_drawers: Array[Drawer] = []
	var nodes = get_tree().get_nodes_in_group(&"memory_drawers")
	for node in nodes:
		if node is Drawer:
			valid_drawers.append(node)
	return valid_drawers


func assign_items() -> void:
	var unused_drawers = drawers.duplicate()
	var unused_items = items.list.duplicate()

	unused_drawers.shuffle()
	unused_items.shuffle()

	while unused_drawers.size() > 0 && unused_items.size() > 0:
		var item: MemoryItem = unused_items.pop_back()
		for i in 2:
			var drawer: Drawer = unused_drawers.pop_back()
			drawer.assign_item(item)


func animate_start() -> void:
	current_drawer = drawers.pick_random() as Drawer
	var screen_half_width := get_viewport().get_visible_rect().size.x * 0.5
	var hand_position := current_drawer.global_position
	var hand_rotation: float = inverse_lerp(0.0, screen_half_width, hand_position.x) * HAND_ROTATION

	game_state = GAME_STATE.Moving

	var tween := create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(hand, ^"global_position", hand_position, 1.0)
	tween.tween_property(hand, ^"global_rotation_degrees", hand_rotation, 1.0)

	await tween.finished

	game_state = GAME_STATE.Ready


func _process(_delta: float) -> void:
	if game_state == GAME_STATE.Ready:
		# Handle action
		if Input.is_action_just_pressed(&"action"):
			if current_drawer:
				current_drawer.toggle()
			#if hovered_drawers.size() > 0:
				#hovered_drawers.back().toggle()
		# Handle move
		var input_dir := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
		var cardinal_direction = get_cardinal_direction(input_dir)
		move_hand(cardinal_direction)


func get_cardinal_direction(direction: Vector2) -> Vector2:
	if direction.length_squared() > 0:
		direction = direction.normalized()
		var to_up: float = abs(direction.angle_to(Vector2.UP))
		var to_right: float = abs(direction.angle_to(Vector2.RIGHT))
		var to_down: float = abs(direction.angle_to(Vector2.DOWN))
		var to_left: float = abs(direction.angle_to(Vector2.LEFT))
		if min(to_up, to_right, to_down, to_left) == to_up:
			return Vector2.UP
		elif min(to_up, to_right, to_down, to_left) == to_right:
			return Vector2.RIGHT
		elif min(to_up, to_right, to_down, to_left) == to_down:
			return Vector2.DOWN
		elif min(to_up, to_right, to_down, to_left) == to_left:
			return Vector2.LEFT
	return Vector2.ZERO


func _physics_process(delta: float) -> void:
	pass
	# Move and rotate hand
	#if game_state == GAME_STATE.Playing:
		#var screen_half_width := get_viewport().get_visible_rect().size.x * 0.5
		#var hand_position := current_drawer.global_position
		#var hand_rotation: float = inverse_lerp(0.0, screen_half_width, hand_position.x) * HAND_ROTATION
		#hand.global_position = hand.global_position.lerp(hand_position, 1.0 - exp(-delta * HAND_SPEED))
		#hand.global_rotation_degrees = hand_rotation


func move_hand(direction: Vector2) -> void:
	var target_drawer: Drawer = null
	match direction:
		Vector2.UP:
			if current_drawer.up_drawer:
				target_drawer = current_drawer.up_drawer
		Vector2.RIGHT:
			if current_drawer.right_drawer:
				target_drawer = current_drawer.right_drawer
		Vector2.DOWN:
			if current_drawer.down_drawer:
				target_drawer = current_drawer.down_drawer
		Vector2.LEFT:
			if current_drawer.left_drawer:
				target_drawer = current_drawer.left_drawer
		_: return

	if target_drawer && target_drawer != current_drawer:
		game_state = GAME_STATE.Moving
		current_drawer = target_drawer

		var screen_half_width := get_viewport().get_visible_rect().size.x * 0.5
		var hand_position := current_drawer.global_position
		var hand_rotation: float = inverse_lerp(0.0, screen_half_width, hand_position.x) * HAND_ROTATION

		var tween := create_tween()
		tween.set_parallel()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(hand, ^"global_position", hand_position, 0.5)
		tween.tween_property(hand, ^"global_rotation_degrees", hand_rotation, 0.5)

		await tween.finished

		game_state = GAME_STATE.Ready


func on_hand_area_entered(area: Area2D) -> void:
	if area is Drawer:
		# Stop highlighting other drawers
		for drawer in hovered_drawers:
			drawer.highlight(false)
		# Add new drawer and highlight it
		hovered_drawers.append(area)
		area.highlight()


func on_hand_area_exited(area: Area2D) -> void:
	if area is Drawer:
		# Remove from list and stop highlighting
		hovered_drawers.erase(area)
		area.highlight(false)
		# Highlight next latest drawer instead
		if hovered_drawers.size() > 0:
			hovered_drawers.back().highlight()
