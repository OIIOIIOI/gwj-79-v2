extends Node2D
class_name WeightLifting


const UP_SPEED := 80.0
const DOWN_SPEED := 50.0

enum GAME_STATE {
	Initializing,
	Ready,
	End,
}


var game_state: GAME_STATE = GAME_STATE.Initializing
var target_position := Vector2.ZERO


@onready var arm: Node2D = $Arm
@onready var start_marker: Marker2D = $StartMarker
@onready var end_marker: Marker2D = $EndMarker


func _ready() -> void:
	animate_start()


func animate_start() -> void:
	target_position = start_marker.global_position

	var tween := create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(arm, ^"global_position", target_position, 1.0)

	await tween.finished

	game_state = GAME_STATE.Ready


func _process(delta: float) -> void:
	if game_state == GAME_STATE.Ready:
		# Handle action
		if Input.is_action_just_pressed(&"action"):
			target_position.y -= UP_SPEED * (1.0 - get_progress())
		# Move down
		if (target_position.y < start_marker.global_position.y):
			target_position.y += DOWN_SPEED * delta

		# Clamp and update
		target_position.y = clampf(target_position.y, end_marker.global_position.y, start_marker.global_position.y)
		arm.global_position = target_position


func get_progress() -> float:
	var r = inverse_lerp(start_marker.global_position.y, end_marker.global_position.y, arm.global_position.y)
	return abs(clampf(r, 0.25, 1.0))
