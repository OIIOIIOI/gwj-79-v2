extends Node


var steps: Array[String] = []
var latest_player_position: Vector3 = Vector3.ZERO
var latest_player_facing_left: bool = false


func _ready() -> void:
	on_step_added(GameEnums.STEPS.Step_JustStarted)

	GameEvents.step_added.connect(on_step_added)
	GameEvents.scene_transition_requested.connect(on_scene_transition_requested)


func has_step(step: GameEnums.STEPS) -> bool:
	return steps.has(GameEnums.STEPS.find_key(step))


func is_current_step(step: GameEnums.STEPS) -> bool:
	if steps.is_empty():
		return false
	return steps.back() == GameEnums.STEPS.find_key(step)


func on_step_added(step: GameEnums.STEPS) -> void:
	var step_name = GameEnums.STEPS.find_key(step)
	if !steps.has(step_name):
		steps.append(step_name)
		# print("Step added: ", step_name)


func on_scene_transition_requested(_scene: GameEnums.SCENES) -> void:
	var player = get_tree().get_first_node_in_group(&"player")
	if player is Player:
		latest_player_position = player.position
		latest_player_facing_left = player.facing_left
