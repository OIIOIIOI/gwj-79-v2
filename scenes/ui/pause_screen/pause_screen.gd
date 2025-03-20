extends CanvasLayer
class_name PauseScreen


enum STATE {
	Initializing,
	Open,
	Closed,
}

var state: STATE = STATE.Initializing

@onready var resume_button: Button = %ResumeButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	resume_button.pressed.connect(on_resume_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)

	visible = false
	state = STATE.Closed


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		if state == STATE.Closed:
			open()
			get_tree().root.set_input_as_handled()
		elif state == STATE.Open:
			close()
			get_tree().root.set_input_as_handled()


func open():
	get_tree().paused = true
	visible = true
	resume_button.grab_focus()
	state = STATE.Open


func close():
	visible = false
	get_tree().paused = false
	state = STATE.Closed


func on_resume_button_pressed() -> void:
	close()


func on_quit_button_pressed() -> void:
	SceneTransition.transition_to(GameEnums.SCENES.Scene_Title)
