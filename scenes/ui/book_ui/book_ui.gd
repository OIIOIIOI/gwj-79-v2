extends CanvasLayer
class_name BookUI


enum STATE {
	Initializing,
	Open,
	Closed,
}


@export var step_1_texture: Texture2D
@export var step_2_texture: Texture2D
@export var step_3_texture: Texture2D
@export var step_4_texture: Texture2D


var state: STATE = STATE.Initializing


@onready var book_texture: TextureRect = $BookTexture
@onready var open_sfx: AudioStreamPlayer = $OpenSFX
@onready var close_sfx: AudioStreamPlayer = $CloseSFX


func _ready() -> void:
	visible = false
	book_texture.texture = step_1_texture
	state = STATE.Closed

	GameEvents.step_added.connect(on_step_added)


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

	GameEvents.book_opened.emit()

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

	GameEvents.book_closed.emit()


func on_step_added(step: GameEnums.STEPS) -> void:
	if step == GameEnums.STEPS.Step_DroppedSeed:
		book_texture.texture = step_2_texture
	elif step == GameEnums.STEPS.Step_DroppedWeapon:
		book_texture.texture = step_3_texture
	elif step == GameEnums.STEPS.Step_DroppedEmerald:
		book_texture.texture = step_4_texture
