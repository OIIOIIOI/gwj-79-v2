extends CanvasLayer
class_name BookUI


enum STATE {
	Initializing,
	Open,
	Closed,
}

var state: STATE = STATE.Initializing


@onready var book_texture: TextureRect = $BookTexture
@onready var open_sfx: AudioStreamPlayer = $OpenSFX
@onready var close_sfx: AudioStreamPlayer = $CloseSFX


func _ready() -> void:
	visible = false
	state = STATE.Closed


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"open_book"):
		if state == STATE.Closed:
			open()
			get_tree().root.set_input_as_handled()
		elif state == STATE.Open:
			close()
			get_tree().root.set_input_as_handled()


func open():
	get_tree().paused = true
	open_sfx.play()
	visible = true
	state = STATE.Open

	# Add step if first time
	if !GameData.has_step(GameEnums.STEPS.Step_BookChecked):
		var action = AddStepAction.new()
		action.step = GameEnums.STEPS.Step_BookChecked
		GameEvents.execute_action(action)



func close():
	close_sfx.play()
	visible = false
	get_tree().paused = false
	state = STATE.Closed
