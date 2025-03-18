extends CanvasLayer


signal transition_halfway


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


#func transition_to_location(location: GameEnums.WARP_LOCATION):
	transition()

	await transition_halfway

	get_tree().paused = false

	#match location:
		#0: get_tree().change_scene_to_packed(location_town_square)
		#1: get_tree().change_scene_to_packed(location_library)
		#_: get_tree().change_scene_to_packed(title_scene)


func transition_to_title():
	#transition_to_packed(title_scene)
	pass
