extends CanvasLayer


@export var play_scene: PackedScene


@onready var play_button: Button = %PlayButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	play_button.pressed.connect(on_play_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)

	play_button.grab_focus()


func on_play_button_pressed() -> void:
	if play_scene:
		SceneTransition.transition_to_packed(play_scene)


func on_quit_button_pressed() -> void:
	get_tree().quit()
