extends CanvasLayer
class_name TitleScreen


@onready var play_button: Button = %PlayButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	play_button.pressed.connect(on_play_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)

	play_button.grab_focus()


func on_play_button_pressed() -> void:
	SceneTransition.transition_to(SceneTransition.SCENE_MAIN)


func on_quit_button_pressed() -> void:
	get_tree().quit()
