extends CanvasLayer


signal transition_halfway


const SCENE_TITLE := "scene_title"
const SCENE_MAIN := "scene_main"
const SCENE_MEMORY := "scene_memory"
const SCENE_WEIGHT_LIFTING := "scene_weight_lifting"
const SCENE_HAMMER_TIME := "scene_hammer_time"

const scenes: Dictionary = {
	SCENE_TITLE: preload("res://scenes/ui/title_screen/title_screen.tscn"),
	SCENE_MAIN: preload("res://scenes/main/main.tscn"),
	SCENE_MEMORY: preload("res://scenes/mini_games/memory/memory.tscn"),
	SCENE_WEIGHT_LIFTING: preload("res://scenes/mini_games/weight_lifting/weight_lifting.tscn"),
	SCENE_HAMMER_TIME: preload("res://scenes/mini_games/hammer_time/hammer_time.tscn"),
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


func transition_to(scene_name: String) -> void:
	if scenes.has(scene_name):
		transition_to_packed(scenes.get(scene_name))
