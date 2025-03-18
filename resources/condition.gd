extends Resource
class_name Condition


enum CONDITION_TYPE {
	CurrentStepIs,
}


@export var type: CONDITION_TYPE = CONDITION_TYPE.CurrentStepIs
@export var value := ""


func check() -> bool:
	match type:
		CONDITION_TYPE.CurrentStepIs:
			print("CHECK CurrentStepIs: ", GameData.steps.back(), ", expected: ", value)
			return GameData.steps.back() == value
		_:
			return false
