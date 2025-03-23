extends Node


signal dialog_started
signal dialog_ended
signal step_added(step: GameEnums.STEPS)
signal book_opened
signal book_closed
signal tree_grown
signal book_update_started
signal book_update_finished
signal scene_transition_requested(scene: GameEnums.SCENES)


func execute_action(action:Action) -> void:
	# Load scene
	if action is LoadSceneAction:
		scene_transition_requested.emit(action.scene)
		SceneTransition.transition_to(action.scene)
	# Add step
	elif action is AddStepAction:
		step_added.emit(action.step)
	# Unknown action
	else:
		print("Unknown Action: ", action)
