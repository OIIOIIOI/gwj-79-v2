extends Resource
class_name DialogChunk


enum DIALOG_CHUNK_STYLE {
	Normal,
}


@export var speaker_name: Texture2D = null
@export var speaker_sprite: Texture2D = null
@export var text := ""
@export var sfx: AudioStream
@export var style: DialogChunk.DIALOG_CHUNK_STYLE = DIALOG_CHUNK_STYLE.Normal
@export var actions: Array[Action] = []
