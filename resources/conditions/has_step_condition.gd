extends Condition
class_name HasStepCondition


@export var step: GameEnums.STEPS


func check() -> bool:
	return GameData.has_step(step)
