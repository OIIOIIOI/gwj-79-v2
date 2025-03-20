extends Condition
class_name HasObjectCondition


@export var object: GameEnums.OBJECTS


func check() -> bool:
	return GameData.has_object(object)
