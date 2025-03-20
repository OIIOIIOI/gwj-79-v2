extends Action
class_name AddRemoveObjectAction


enum OBJECT_ACTION {
	Add,
	Remove,
}


@export var object: GameEnums.OBJECTS
@export var action: OBJECT_ACTION
