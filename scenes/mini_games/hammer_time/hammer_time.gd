extends Node2D
class_name HammerTime


func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	SceneTransition.transition_to(GameEnums.SCENES.Scene_Main)
