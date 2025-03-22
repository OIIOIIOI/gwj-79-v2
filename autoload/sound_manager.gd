extends Node


@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	audio_stream_player.play()

	GameEvents.step_added.connect(on_step_added)


func on_step_added(step: GameEnums.STEPS) -> void:
	if !audio_stream_player.playing:
		return

	var sp: AudioStreamPlaybackInteractive = audio_stream_player.get_stream_playback()
	if !sp:
		return

	match step:
		GameEnums.STEPS.Step_GameStarted:
			sp.switch_to_clip_by_name(&"Trans 1")
		GameEnums.STEPS.Step_DroppedSeed:
			sp.switch_to_clip_by_name(&"Trans 2")
		GameEnums.STEPS.Step_DroppedEmerald:
			sp.switch_to_clip_by_name(&"Trans 3")
