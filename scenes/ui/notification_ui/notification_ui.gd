extends CanvasLayer


var notification_scene: PackedScene = preload("res://scenes/ui/notification_ui/notification.tscn")


@onready var container: VBoxContainer = $MarginContainer/VBoxContainer


func _ready() -> void:
	GameEvents.step_added.connect(on_step_added)


func on_step_added(step: GameEnums.STEPS) -> void:
	match step:
		# Object obtained
		GameEnums.STEPS.Step_ObtainedBook:
			add_notification("Mysterious Book obtained!")
		GameEnums.STEPS.Step_ObtainedSeed:
			add_notification("City Seal obtained!")
		GameEnums.STEPS.Step_ObtainedWeapon:
			add_notification("Weapon obtained!")
		GameEnums.STEPS.Step_ObtainedEmerald:
			add_notification("Emerald obtained!")
		# Object dropped
		GameEnums.STEPS.Step_DroppedSeed || GameEnums.STEPS.Step_DroppedWeapon || GameEnums.STEPS.Step_DroppedEmerald:
			await get_tree().create_timer(3.0).timeout
			GameEvents.book_updated.emit()
			add_notification("Something happened to the book!")


func add_notification(text: String) -> void:
	var notif: Notification = notification_scene.instantiate() as Notification
	container.add_child(notif)
	await get_tree().process_frame
	notif.set_text(text)
