extends Node


var steps: Array[String] = ["step_zero"]


func _ready() -> void:
	GameEvents.step_added.connect(on_step_added)


func on_step_added(value: String) -> void:
	print("GameData: step added: ", value)
	steps.append(value)
