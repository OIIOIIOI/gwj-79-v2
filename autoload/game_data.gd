extends Node


var steps: Array[String] = []
var objects: Array[String] = []


func _ready() -> void:
	GameEvents.step_added.connect(on_step_added)
	GameEvents.object_added.connect(on_object_added)
	GameEvents.object_removed.connect(on_object_removed)


func has_step(step: GameEnums.STEPS) -> bool:
	return steps.has(GameEnums.STEPS.find_key(step))


func has_object(object: GameEnums.OBJECTS) -> bool:
	return objects.has(GameEnums.OBJECTS.find_key(object))


func on_step_added(step: GameEnums.STEPS) -> void:
	#var step_name = "step_" + str(step)
	var step_name = GameEnums.STEPS.find_key(step)
	if !steps.has(step_name):
		steps.append(step_name)
		print("Step added: ", step_name)


func on_object_added(object: GameEnums.OBJECTS) -> void:
	#var object_name = "object_" + str(object)
	var object_name = GameEnums.OBJECTS.find_key(object)
	if !objects.has(object_name):
		objects.append(object_name)
		print("Object added: ", object_name)


func on_object_removed(object: GameEnums.OBJECTS) -> void:
	#var object_name = "object_" + str(object)
	var object_name = GameEnums.OBJECTS.find_key(object)
	if objects.has(object_name):
		objects.erase(object_name)
		print("Object removed: ", object_name)
