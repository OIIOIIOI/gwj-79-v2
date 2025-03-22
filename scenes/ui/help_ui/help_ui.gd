extends CanvasLayer


@onready var bottom_label: Label = %BottomLabel


func _ready() -> void:
	hide_ui()

	if !GameData.has_step(GameEnums.STEPS.Step_BookChecked):
		bottom_label.text = "Press TAB to open the Book"
		visible = true

	GameEvents.step_added.connect(on_step_added)


func hide_ui() -> void:
	visible = false
	bottom_label.text = ""


func on_step_added(step: GameEnums.STEPS) -> void:
	if step == GameEnums.STEPS.Step_BookChecked:
		hide_ui()
