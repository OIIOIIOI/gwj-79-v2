extends Node


signal dialog_started()
signal dialog_ended()
signal step_added(step: String)


func execute_action(action:Action) -> void:
	#print("GameEvents execute_action: ", action.type, " ", action.value)
	match action.type:
		Action.ACTION_TYPE.AddStep:
			step_added.emit(action.value)
		Action.ACTION_TYPE.LoadScene:
			SceneTransition.transition_to(action.value)
		_:
			print("Unknown Action type: ", action.type, " with value: ", action.value)
