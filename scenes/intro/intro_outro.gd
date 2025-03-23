extends Node2D
class_name IntroOutro


@export var dialog: Dialog


@onready var dialog_ui: DialogUI = $DialogUI


func _ready() -> void:
	if dialog:
		dialog_ui.start_dialog(dialog)
