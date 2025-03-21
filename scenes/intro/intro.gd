extends Node2D
class_name Intro


var dialog: Dialog = preload("res://resources/dialogs/intro_dialog.tres")


@onready var dialog_ui: DialogUI = $DialogUI


func _ready() -> void:
	dialog_ui.start_dialog(dialog)
