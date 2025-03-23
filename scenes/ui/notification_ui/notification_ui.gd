extends CanvasLayer


var notification_scene: PackedScene = preload("res://scenes/ui/notification_ui/notification.tscn")


@onready var container: VBoxContainer = $MarginContainer/VBoxContainer


func _ready() -> void:
	GameEvents.step_added.connect(on_step_added)
	GameEvents.book_update_started.connect(on_book_update_started)


func on_step_added(step: GameEnums.STEPS) -> void:
	match step:
		# Object obtained
		GameEnums.STEPS.Step_ObtainedBook:
			add_notification("Mysterious Book obtained!")
		GameEnums.STEPS.Step_ObtainedSeed:
			add_notification("City Seal obtained!")
		GameEnums.STEPS.Step_ObtainedWeapon:
			add_notification("Keeper's Baton obtained!")
		GameEnums.STEPS.Step_ObtainedEmerald:
			add_notification("Great Emerald obtained!")


func on_book_update_started() -> void:
	add_notification("Something happened to the book!")


func add_notification(text: String) -> void:
	var notif: Notification = notification_scene.instantiate() as Notification
	container.add_child(notif)
	await get_tree().process_frame
	notif.set_text(text)
