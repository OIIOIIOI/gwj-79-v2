extends Condition
class_name HasStepCondition


@export var step: GameEnums.STEPS


func check() -> bool:
	if invert:
		return !GameData.has_step(step)
	else:
		return GameData.has_step(step)
