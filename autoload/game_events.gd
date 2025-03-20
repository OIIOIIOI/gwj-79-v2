extends Node


signal dialog_started()
signal dialog_ended()
signal step_added(step: GameEnums.STEPS)
signal object_added(object: GameEnums.OBJECTS)
signal object_removed(object: GameEnums.OBJECTS)


func execute_action(action:Action) -> void:
	# Load scene
	if action is LoadSceneAction:
		SceneTransition.transition_to(action.scene)
	# Add step
	elif action is AddStepAction:
		step_added.emit(action.step)
	# Add/remove object
	elif action is AddRemoveObjectAction:
		if action.action == AddRemoveObjectAction.OBJECT_ACTION.Add:
			object_added.emit(action.object)
		elif action.action == AddRemoveObjectAction.OBJECT_ACTION.Remove:
			object_removed.emit(action.object)
	# Unknown action
	else:
		print("Unknown Action: ", action)
