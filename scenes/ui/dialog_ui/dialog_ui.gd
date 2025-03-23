extends CanvasLayer
class_name DialogUI


var is_active := false
var current_dialog: Dialog
var current_chunk: DialogChunk
var current_chunk_index := 0
var is_loading_scene := false


@onready var background: TextureRect = %Background
@onready var speaker_sprite: TextureRect = %SpeakerSprite
@onready var speaker_name: TextureRect = %SpeakerName
@onready var text_panel: Panel = %TextPanel
@onready var text_label: RichTextLabel = %TextLabel
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var auto_advance_timer: Timer = $AutoAdvanceTimer


func _ready() -> void:
	is_active = false
	auto_advance_timer.timeout.connect(display_next_chunk)
	reset_ui()


func reset_ui() -> void:
	visible = false
	background.texture = null
	speaker_sprite.texture = null
	speaker_name.texture = null
	text_label.text = ""


func _process(_delta: float) -> void:
	if is_active && Input.is_action_just_pressed(&"action"):
		display_next_chunk()


func start_dialog(dialog: Dialog) -> void:
	if dialog == null || dialog.chunks.size() == 0:
		return

	var duration := 0.0
	for chunk in dialog.chunks:
		if chunk.duration > 0.0:
			duration += chunk.duration

	background.texture = dialog.background

	visible = true
	current_dialog = dialog
	current_chunk_index = 0

	display_current_chunk()

	GameEvents.dialog_started.emit()

	await get_tree().process_frame
	is_active = true


func end_dialog() -> void:
	if !is_loading_scene:
		reset_ui()

	current_dialog = null
	current_chunk_index = 0
	audio_stream_player.stop()

	GameEvents.dialog_ended.emit()

	await get_tree().process_frame
	is_active = false


func display_current_chunk() -> void:
	current_chunk = current_dialog.chunks[current_chunk_index]

	# Execute chunk actions
	if current_chunk.actions.size() > 0:
		for action in current_chunk.actions:
			if action is LoadSceneAction:
				is_loading_scene = true
			GameEvents.execute_action(action)

	# Play SFX
	if current_chunk.sfx:
		audio_stream_player.stream = current_chunk.sfx
		audio_stream_player.play()

	# Show backgound
	if current_chunk.background:
		background.texture = current_chunk.background

	# Show text
	if !current_chunk.text.is_empty():
		text_panel.visible = true
		# Set text style and content
		text_label.clear()
		match current_chunk.style:
			DialogChunk.DIALOG_CHUNK_STYLE.Bold:
				text_label.append_text("[b]%s[/b]" % [current_chunk.text])
			DialogChunk.DIALOG_CHUNK_STYLE.Italic:
				text_label.append_text("[i]%s[/i]" % [current_chunk.text])
			DialogChunk.DIALOG_CHUNK_STYLE.Old:
				text_label.append_text("[shake rate=10.0 level=3 connected=1]%s[/shake]" % [current_chunk.text])
			_:
				text_label.append_text("%s" % [current_chunk.text])

		# Set speaker sprite and name
		speaker_sprite.texture = current_chunk.speaker_sprite
		speaker_name.texture = current_chunk.speaker_name
	else:
		text_panel.visible = false

	# If nothing to show (action chunk), go next
	if current_chunk.text.is_empty() && current_chunk.background == null:
		display_next_chunk()
	# If auto advance, start timer
	elif current_chunk.duration > 0.0:
		auto_advance_timer.start(current_chunk.duration)


func display_next_chunk() -> void:
	auto_advance_timer.stop()

	if current_chunk_index < current_dialog.chunks.size() - 1:
		current_chunk_index += 1
		display_current_chunk()
	else:
		end_dialog()
