extends CanvasLayer


var notification_scene: PackedScene = preload("res://scenes/ui/notification_ui/notification.tscn")


@onready var container: VBoxContainer = $MarginContainer/VBoxContainer


func _ready() -> void:
	GameEvents.step_added.connect(on_step_added)


func on_step_added(step: GameEnums.STEPS) -> void:
	match step:
		GameEnums.STEPS.Step_ObtainedBook:
			add_notification("Mysterious Book obtained!")
		GameEnums.STEPS.Step_ObtainedSeed:
			add_notification("Seed obtained!")
		GameEnums.STEPS.Step_DroppedSeed:
			await get_tree().create_timer(3.0).timeout
			add_notification("Something happened to the book!")
		GameEnums.STEPS.Step_ObtainedWeapon:
			add_notification("Weapon obtained!")
		GameEnums.STEPS.Step_ObtainedEmerald:
			add_notification("Emerald obtained!")


func add_notification(text: String) -> void:
	var notif: Notification = notification_scene.instantiate() as Notification
	container.add_child(notif)
	await get_tree().process_frame
	notif.set_text(text)
