extends StaticBody3D
class_name Well


@onready var object_drop_sfx: AudioStreamPlayer3D = $ObjectDropSFX
@onready var tree_sfx: AudioStreamPlayer3D = $TreeSFX


func _ready() -> void:
	GameEvents.step_added.connect(on_step_added)


func on_step_added(step: GameEnums.STEPS) -> void:
	match step:
		GameEnums.STEPS.Step_DroppedSeed, GameEnums.STEPS.Step_DroppedWeapon, GameEnums.STEPS.Step_DroppedEmerald, GameEnums.STEPS.Step_DroppedBook:
			object_drop_sfx.play()
			await get_tree().create_timer(2.0).timeout
			tree_sfx.play()
