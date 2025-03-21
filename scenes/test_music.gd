extends Node2D


@onready var button_1: Button = $CanvasLayer/MarginContainer/VBoxContainer/Button1
@onready var button_2: Button = $CanvasLayer/MarginContainer/VBoxContainer/Button2
@onready var button_3: Button = $CanvasLayer/MarginContainer/VBoxContainer/Button3
@onready var button_4: Button = $CanvasLayer/MarginContainer/VBoxContainer/Button4
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	button_1.pressed.connect(on_button_1)
	button_2.pressed.connect(on_button_2)
	button_3.pressed.connect(on_button_3)
	button_4.pressed.connect(on_button_4)


func on_button_1() -> void:
	audio_stream_player.play()


func on_button_2() -> void:
	var sp: AudioStreamPlaybackInteractive = audio_stream_player.get_stream_playback()
	if sp:
		sp.switch_to_clip_by_name(&"Trans 2")


func on_button_3() -> void:
	var sp: AudioStreamPlaybackInteractive = audio_stream_player.get_stream_playback()
	if sp:
		sp.switch_to_clip_by_name(&"Trans 3")


func on_button_4() -> void:
	var sp: AudioStreamPlaybackInteractive = audio_stream_player.get_stream_playback()
	if sp:
		sp.switch_to_clip_by_name(&"Trans 1")
