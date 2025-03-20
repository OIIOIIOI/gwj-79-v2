extends Condition
class_name IsCurrentStepCondition


@export var step: GameEnums.STEPS


func check() -> bool:
	if invert:
		return !GameData.is_current_step(step)
	else:
		return GameData.is_current_step(step)
