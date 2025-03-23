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
var has_book := true
var can_open := true


@onready var book_texture: TextureRect = $BookTexture
@onready var open_sfx: AudioStreamPlayer = $OpenSFX
@onready var close_sfx: AudioStreamPlayer = $CloseSFX
@onready var update_sfx: AudioStreamPlayer = $UpdateSFX


func _ready() -> void:
	visible = false

	update_book_texture()
	state = STATE.Closed

	GameEvents.dialog_started.connect(on_dialog_started)
	GameEvents.dialog_ended.connect(on_dialog_ended)
	GameEvents.tree_grown.connect(on_tree_grown)
	GameEvents.step_added.connect(on_step_added)


func _unhandled_input(event: InputEvent) -> void:
	if has_book && can_open && event.is_action_pressed(&"open_book"):
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


func update_book_texture() -> void:
	if GameData.is_current_step(GameEnums.STEPS.Step_DroppedSeed) || GameData.is_current_step(GameEnums.STEPS.Step_ObtainedWeapon):
		book_texture.texture = step_2_texture
	elif GameData.is_current_step(GameEnums.STEPS.Step_DroppedWeapon) || GameData.is_current_step(GameEnums.STEPS.Step_ObtainedEmerald):
		book_texture.texture = step_3_texture
	elif GameData.is_current_step(GameEnums.STEPS.Step_DroppedEmerald):
		book_texture.texture = step_4_texture
	else:
		book_texture.texture = step_1_texture


func on_tree_grown() -> void:
	update_book_texture()

	if !GameData.is_current_step(GameEnums.STEPS.Step_DroppedBook):
		update_sfx.play()
		await get_tree().create_timer(2.0).timeout
		GameEvents.book_update_started.emit()
		await update_sfx.finished
		GameEvents.book_update_finished.emit()


func on_step_added(step: GameEnums.STEPS) -> void:
	if step == GameEnums.STEPS.Step_DroppedBook:
		has_book = false


func on_dialog_started() -> void:
	can_open = false


func on_dialog_ended() -> void:
	can_open = true
