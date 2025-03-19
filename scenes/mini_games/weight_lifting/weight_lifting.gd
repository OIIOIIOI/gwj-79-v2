extends Node2D
class_name WeightLifting


const UP_SPEED := 80.0
const DOWN_SPEED := 50.0
const WIN_HOLD_THRESHOLD := 0.85
const WIN_HOLD_DURATION := 3.0

enum GAME_STATE {
	Initializing,
	Ready,
	End,
}


var game_state: GAME_STATE = GAME_STATE.Initializing
var arm_target_position := Vector2.ZERO
var held_time := 0.0


@onready var goal_line: Sprite2D = $GoalLine

@onready var arm: Node2D = $Arm
@onready var start_marker: Marker2D = $StartMarker
@onready var end_marker: Marker2D = $EndMarker

@onready var mayor_arm: Node2D = $MayorArm
@onready var mayor_start_marker: Marker2D = $MayorStartMarker
@onready var mayor_end_marker: Marker2D = $MayorEndMarker
@onready var mayor_win_marker: Marker2D = $MayorWinMarker



func _ready() -> void:
	reset_visuals()
	sync_mayor_position(0.0)
	animate_start()


func animate_start() -> void:
	arm_target_position = start_marker.global_position

	var tween := create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(arm, ^"global_position", arm_target_position, 1.0)

	await tween.finished

	game_state = GAME_STATE.Ready


func _process(delta: float) -> void:
	if game_state == GAME_STATE.Ready:
		# Handle action
		if Input.is_action_just_pressed(&"action"):
			arm_target_position.y -= UP_SPEED * (1.0 - get_progress())
		# Move down
		if (arm_target_position.y < start_marker.global_position.y):
			arm_target_position.y += DOWN_SPEED * delta

		# Clamp and update
		arm_target_position.y = clampf(arm_target_position.y, end_marker.global_position.y, start_marker.global_position.y)
		arm.global_position = arm_target_position

		# Update win progress
		if get_progress() >= WIN_HOLD_THRESHOLD:
			held_time += delta
		else:
			held_time = 0.0

		# Sync mayor thumbs up
		sync_mayor_position(get_hold_progress())

		# If win, end game
		if get_hold_progress() == 1.0:
			end_game()


func get_progress() -> float:
	var r = inverse_lerp(start_marker.global_position.y, end_marker.global_position.y, arm.global_position.y)
	return abs(clampf(r, 0.25, 1.0))


func get_hold_progress() -> float:
	var r = inverse_lerp(0.0, WIN_HOLD_DURATION, held_time)
	return abs(clampf(r, 0.0, 1.0))


func reset_visuals() -> void:
	mayor_arm.global_position = mayor_start_marker.global_position
	mayor_arm.rotation = mayor_start_marker.rotation
	mayor_arm.scale = mayor_start_marker.scale

	goal_line.global_position.y = lerpf(start_marker.global_position.y, end_marker.global_position.y, WIN_HOLD_THRESHOLD)


func sync_mayor_position(progress: float) -> void:
	var target_position: Vector2 = mayor_start_marker.global_position.lerp(mayor_end_marker.global_position, progress)
	var target_rotation = lerp(mayor_start_marker.rotation, mayor_end_marker.rotation, progress)
	var target_scale = mayor_start_marker.scale.lerp(mayor_end_marker.scale, progress)

	var ratio = 0.5
	mayor_arm.global_position.lerp(target_position, ratio)
	mayor_arm.rotation = lerp(mayor_arm.rotation, target_rotation, ratio)
	mayor_arm.scale.lerp(target_scale, ratio)


func end_game() -> void:
	game_state = GAME_STATE.End

	var tween_duration := 1.0
	var tween := create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(mayor_arm, ^"global_position", mayor_win_marker.global_position, tween_duration)
	tween.tween_property(mayor_arm, ^"rotation", mayor_win_marker.rotation, tween_duration)
	tween.tween_property(mayor_arm, ^"scale", mayor_win_marker.scale, tween_duration)

	await tween.finished
	await get_tree().create_timer(0.75).timeout

	SceneTransition.transition_to(SceneTransition.SCENE_MAIN)
