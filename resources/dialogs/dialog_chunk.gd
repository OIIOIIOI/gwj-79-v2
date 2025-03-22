extends Resource
class_name DialogChunk


enum DIALOG_CHUNK_STYLE {
	Normal,
	Bold,
	Italic,
	Old,
}


@export var background: Texture2D = null
@export var speaker_name: Texture2D = null
@export var speaker_sprite: Texture2D = null
@export_multiline var text := ""
@export var style: DialogChunk.DIALOG_CHUNK_STYLE = DIALOG_CHUNK_STYLE.Normal
@export var duration: float = 0.0
@export var sfx: AudioStream
@export var actions: Array[Action] = []
