@tool
extends Node
class_name RandomAudioPauseComponent


@export var min_delay: float = 8.0
@export var max_delay: float = 20.0


var asp: AudioStreamPlayer3D


func _get_configuration_warnings() -> PackedStringArray:
	var warnings = PackedStringArray()
	if get_parent() == null || !(get_parent() is AudioStreamPlayer3D):
		warnings.append("This component must be a child of an AudioStreamPlayer3D.")
	return warnings


func _enter_tree() -> void:
	update_configuration_warnings()


func _ready() -> void:
	if get_parent() == null || !(get_parent() is AudioStreamPlayer3D):
		return

	asp = get_parent() as AudioStreamPlayer3D
	await get_parent().ready

	asp.finished.connect(start_random_timer)
	start_random_timer()


func start_random_timer() -> void:
	var delay = randf_range(min_delay, max_delay)
	await get_tree().create_timer(delay).timeout
	play_stream()


func play_stream() -> void:
	asp.play()
