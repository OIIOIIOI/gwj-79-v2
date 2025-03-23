extends CanvasLayer


signal transition_halfway


const scenes: Dictionary = {
	GameEnums.SCENES.Scene_Title: preload("res://scenes/ui/title_screen/title_screen.tscn"),
	GameEnums.SCENES.Scene_Main: preload("res://scenes/main/main.tscn"),
	GameEnums.SCENES.Scene_WeightLifting: preload("res://scenes/mini_games/weight_lifting/weight_lifting.tscn"),
	GameEnums.SCENES.Scene_HammerTime: preload("res://scenes/mini_games/hammer_time/hammer_time.tscn"),
	GameEnums.SCENES.Scene_Memory: preload("res://scenes/mini_games/memory/memory.tscn"),
	GameEnums.SCENES.Scene_Intro: preload("res://scenes/intro/intro.tscn"),
	GameEnums.SCENES.Scene_Outro: preload("res://scenes/outro/outro.tscn"),
	GameEnums.SCENES.Scene_Music: preload("res://scenes/test_music.tscn"),
}


var skip_emit = false


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func emit_transition_halfway():
	if skip_emit:
		return

	transition_halfway.emit()


func transition():
	skip_emit = false
	animation_player.play(&"default")

	await transition_halfway

	skip_emit = true
	animation_player.play_backwards(&"default")


func transition_to_packed(scene: PackedScene, paused: bool = false):
	transition()

	await transition_halfway

	get_tree().paused = paused
	get_tree().change_scene_to_packed(scene)


func transition_to(scene: GameEnums.SCENES) -> void:
	if scenes.has(scene):
		transition_to_packed(scenes.get(scene))
