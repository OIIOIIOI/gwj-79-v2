extends CanvasLayer
class_name DialogUI


var is_active := false
var current_dialog: Dialog
var current_chunk_index := 0


@onready var background: TextureRect = %Background
@onready var speaker_sprite: TextureRect = %SpeakerSprite
@onready var speaker_name: TextureRect = %SpeakerName
@onready var text_label: RichTextLabel = %TextLabel
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	is_active = false
	reset_ui()


func reset_ui() -> void:
	visible = false
	background.texture = null
	speaker_sprite.texture = null
	speaker_name.texture = null
	text_label.text = ""


func _process(_delta: float) -> void:
	if is_active && Input.is_action_just_pressed(&"action"):
		#print("DialogUI Action detected: ", current_dialog)
		display_next_chunk()


func start_dialog(dialog: Dialog) -> void:
	if dialog == null || dialog.chunks.size() == 0:
		return

	background.texture = dialog.background

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
	audio_stream_player.stop()

	GameEvents.dialog_ended.emit()

	await get_tree().process_frame
	is_active = false


func display_current_chunk() -> void:
	var chunk := current_dialog.chunks[current_chunk_index]

	if !chunk.text.is_empty():
		# Set text style and content
		text_label.clear()
		match chunk.style:
			#DialogChunk.DIALOG_CHUNK_STYLE.Comment:
				#text_label.push_italics()
				#text_label.append_text(chunk.text)
				#text_label.pop()
			#DialogChunk.DIALOG_CHUNK_STYLE.Red:
				#text_label.push_bold()
				#text_label.push_color(Color.RED)
				#text_label.append_text(chunk.text)
				#text_label.pop_all()
			_:
				text_label.append_text(chunk.text)

		# Set speaker sprite and name
		speaker_sprite.texture = chunk.speaker_sprite
		speaker_name.texture = chunk.speaker_name

		# Force a layout refresh to fix positioning bug
		visible = false
		visible = true

	# Execute chunk actions
	if chunk.actions.size() > 0:
		for action in chunk.actions:
			GameEvents.execute_action(action)

	# Play SFX
	if chunk.sfx:
		audio_stream_player.stream = chunk.sfx
		audio_stream_player.play()


func display_next_chunk() -> void:
	if current_chunk_index < current_dialog.chunks.size() - 1:
		current_chunk_index += 1
		display_current_chunk()
	else:
		end_dialog()
