extends Node2D
class_name Memory


const HAND_MOVE_DURATION := 0.3
const HAND_ROTATION := 15.0

enum GAME_STATE {
	Initializing,
	Ready,
	Moving,
	Opening,
	Checking,
	End,
}


@export var items: MemoryItems

var drawers: Array[Drawer]
var opened_drawers: Array[Drawer] = []
var current_drawer: Drawer
var game_state: GAME_STATE = GAME_STATE.Initializing


@onready var hand: Hand = $Hand
@onready var win_sfx: AudioStreamPlayer = $WinSFX
@onready var lose_sfx: AudioStreamPlayer = $LoseSFX


func _ready() -> void:
	drawers = get_all_drawers()
	assign_items()
	animate_start()


func get_all_drawers() -> Array[Drawer]:
	var valid_drawers: Array[Drawer] = []
	var nodes = get_tree().get_nodes_in_group(&"memory_drawers")
	for node in nodes:
		if node is Drawer:
			valid_drawers.append(node)
	return valid_drawers


func count_gone_drawers() -> int:
	var i = 0
	for drawer in drawers:
		if drawer.is_gone:
			i += 1
	return i


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
	var hand_position := current_drawer.hand_target.global_position
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
		# TODO Remove this
		# Handle cheat
		if Input.is_action_just_pressed(&"open_book"):
			end_game()

		# Handle action
		if Input.is_action_just_pressed(&"action"):
			if current_drawer && !current_drawer.is_open:
				open_drawer(current_drawer)

		# Handle move
		var input_dir := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
		var cardinal_direction = get_cardinal_direction(input_dir)
		move_hand(cardinal_direction)


func _physics_process(_delta: float) -> void:
	if game_state == GAME_STATE.Opening || game_state == GAME_STATE.Checking:
		hand.global_position = current_drawer.hand_target.global_position


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


func get_target_drawer(from: Drawer, direction: Vector2) -> Drawer:
	var target_drawer: Drawer = null
	match direction:
		Vector2.UP:
			if from.up_drawer:
				target_drawer = from.up_drawer
		Vector2.RIGHT:
			if from.right_drawer:
				target_drawer = from.right_drawer
		Vector2.DOWN:
			if from.down_drawer:
				target_drawer = from.down_drawer
		Vector2.LEFT:
			if from.left_drawer:
				target_drawer = from.left_drawer
		_: return null

	#if target_drawer.is_gone || target_drawer.is_open:
		#return get_target_drawer(target_drawer, direction)

	return target_drawer


func move_hand(direction: Vector2) -> void:
	var target_drawer: Drawer = get_target_drawer(current_drawer, direction)
	if target_drawer && target_drawer != current_drawer:
		game_state = GAME_STATE.Moving
		current_drawer = target_drawer

		var screen_half_width := get_viewport().get_visible_rect().size.x * 0.5
		var hand_position := current_drawer.hand_target.global_position
		var hand_rotation: float = inverse_lerp(0.0, screen_half_width, hand_position.x) * HAND_ROTATION

		var tween := create_tween()
		tween.set_parallel()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(hand, ^"global_position", hand_position, HAND_MOVE_DURATION)
		tween.tween_property(hand, ^"global_rotation_degrees", hand_rotation, HAND_MOVE_DURATION)

		await tween.finished

		game_state = GAME_STATE.Ready


func open_drawer(drawer: Drawer) -> void:
	game_state = GAME_STATE.Opening

	drawer.open()
	await drawer.animation_player.animation_finished

	opened_drawers.append(drawer)
	check_results()


func check_results() -> void:
	game_state = GAME_STATE.Checking

	if opened_drawers.size() < 2:
		game_state = GAME_STATE.Ready
		return

	await get_tree().create_timer(0.5).timeout

	var first_drawer = opened_drawers[0]
	var second_drawer = opened_drawers[1]
	if first_drawer.item == second_drawer.item:
		first_drawer.fade()
		await get_tree().create_timer(0.1).timeout
		second_drawer.fade()
	else:
		lose_sfx.play()
		first_drawer.close()
		await get_tree().create_timer(0.1).timeout
		second_drawer.close()

	await second_drawer.animation_player.animation_finished

	opened_drawers.clear()

	if (count_gone_drawers() == drawers.size()):
		end_game()
	else:
		game_state = GAME_STATE.Ready


func end_game() -> void:
	game_state = GAME_STATE.End

	win_sfx.play()
	await win_sfx.finished

	#await get_tree().create_timer(0.5).timeout

	SceneTransition.transition_to(GameEnums.SCENES.Scene_Main)
