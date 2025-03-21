extends PanelContainer
class_name Notification


@onready var label: Label = $MarginContainer/Label


func _ready() -> void:
	label.text = ""


func set_text(text: String) -> void:
	label.text = text

	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_method(tween_show, 0.0, 1.0, 0.8)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_method(tween_hide, 1.0, 0.0, 0.5).set_delay(5.8)

	await tween.finished
	queue_free()


func tween_show(value: float) -> void:
	scale.x = value


func tween_hide(value: float) -> void:
	modulate.a = value
