extends CanvasLayer
class_name DialogUI


var is_active := false
var current_dialog: Dialog
var current_chunk_index := 0


@onready var name_panel: Panel = %NamePanel
@onready var name_label: Label = %NameLabel
@onready var text_label: RichTextLabel = %TextLabel
@onready var speaker_sprite: TextureRect = %SpeakerSprite


func _ready() -> void:
	is_active = false
	reset_ui()


func reset_ui() -> void:
	visible = false
	name_panel.visible = false
	name_label.text = ""
	text_label.text = ""
	speaker_sprite.texture = null


func _process(_delta: float) -> void:
	if is_active && Input.is_action_just_pressed(&"action"):
		print("DialogUI Action detected: ", current_dialog)
		display_next_chunk()


func start_dialog(dialog: Dialog) -> void:
	if dialog == null || dialog.chunks.size() == 0:
		return

	visible = true
	current_dialog = dialog
	current_chunk_index = 0

	display_current_chunk()

	GameEvents.dialog_started.emit()

	await get_tree().process_frame
	is_active = true


func end_dialog() -> void:
	reset_ui()

	current_dialog = null
	current_chunk_index = 0

	GameEvents.dialog_ended.emit()

	await get_tree().process_frame
	is_active = false


func display_current_chunk() -> void:
	var chunk := current_dialog.chunks[current_chunk_index]

	# Set text style and content
	#text_label.text = ""
	text_label.clear()
	match chunk.style:
		DialogChunk.DIALOG_CHUNK_STYLE.Comment:
			text_label.push_italics()
			text_label.append_text(chunk.text)
			text_label.pop()
		DialogChunk.DIALOG_CHUNK_STYLE.Red:
			text_label.push_bold()
			text_label.push_color(Color.RED)
			text_label.append_text(chunk.text)
			text_label.pop_all()
		_:
			text_label.append_text(chunk.text)

	# Show speaker name if specified
	if !chunk.speaker_name.is_empty():
		name_label.text = chunk.speaker_name
		name_panel.visible = true
	else:
		name_label.text = ""
		name_panel.visible = false

	# Set speaker sprite if specified
	if chunk.sprite:
		speaker_sprite.texture = chunk.sprite
	else:
		speaker_sprite.texture = null

	# Force a layout refresh to fix positioning bug
	visible = false
	visible = true


func display_next_chunk() -> void:
	if current_chunk_index < current_dialog.chunks.size() - 1:
		current_chunk_index += 1
		display_current_chunk()
	else:
		end_dialog()
