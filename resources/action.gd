extends Resource
class_name Action


enum ACTION_TYPE {
	AddStep,
	LoadScene,
}


@export var type: ACTION_TYPE = ACTION_TYPE.AddStep
@export var value := ""
