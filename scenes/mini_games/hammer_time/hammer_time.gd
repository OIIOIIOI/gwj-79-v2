extends Node2D
class_name HammerTime


enum GAME_STATE {
	Initializing,
	Ready,
	End,
}


var game_state: GAME_STATE = GAME_STATE.Initializing


@onready var nail: Nail = $Nail


func _ready() -> void:
	#await get_tree().create_timer(2.0).timeout
	#SceneTransition.transition_to(GameEnums.SCENES.Scene_Main)
	game_state = GAME_STATE.Ready
	pass



func _process(_delta: float) -> void:
	if game_state == GAME_STATE.Ready:
		# TODO Remove this
		# Handle cheat
		if Input.is_action_just_pressed(&"open_book"):
			end_game()

		# Handle action
		if Input.is_action_just_pressed(&"action"):
			nail.hit()



func end_game() -> void:
	game_state = GAME_STATE.End

	#win_sfx.play()
	#await win_sfx.finished

	#await get_tree().create_timer(0.5).timeout

	SceneTransition.transition_to(GameEnums.SCENES.Scene_Main)
