extends Condition
class_name HasObjectCondition


@export var object: GameEnums.OBJECTS


func check() -> bool:
	if invert:
		return !GameData.has_object(object)
	else:
		return GameData.has_object(object)
