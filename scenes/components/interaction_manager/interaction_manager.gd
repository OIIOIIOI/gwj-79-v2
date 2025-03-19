extends Node
class_name InteractionManager


@export var dialog_ui: DialogUI
@export var can_interact := true


func _ready() -> void:
	GameEvents.dialog_started.connect(on_dialog_started)
	GameEvents.dialog_ended.connect(on_dialog_ended)


func _process(_delta: float) -> void:
	if can_interact && Input.is_action_just_pressed(&"action"):
		print("InteractionManager Action detected")
		activate_closest_interactable()


func activate_closest_interactable() -> void:
	var all_valid := get_valid_interactables()
	print("Found ", all_valid.size(), " valid interactables")
	var closest := get_closest_interactable(all_valid)
	if closest:
		print("Closest: ", closest.name)
		activate_interactable(closest)


func get_valid_interactables() -> Array[InteractionComponent]:
	var valid_interactables: Array[InteractionComponent] = []

	var interactables = get_tree().get_nodes_in_group(&"interactables")
	print("interactables: ", interactables.size())
	for interactable in interactables:
		if interactable is InteractionComponent:
			if interactable.is_valid():
				valid_interactables.append(interactable)

	return valid_interactables


func get_closest_interactable(interactables: Array[InteractionComponent]) -> InteractionComponent:
	if interactables.size() == 0:
		return null
	elif interactables.size() == 1:
		return interactables[0]
	else:
		var player = get_tree().get_first_node_in_group(&"player")
		if player is Player:
			var closest_interactable := interactables[0]
			var closest_distance := INF
			var player_position: Vector3 = player.global_position
			for interactable in interactables:
				var distance := interactable.global_position.distance_squared_to(player_position)
				if distance < closest_distance:
					closest_distance = distance
					closest_interactable = interactable
			return closest_interactable
		else:
			return interactables[0]


func activate_interactable(interactable: InteractionComponent) -> void:
	# Start dialog if possible
	if interactable.dialog && dialog_ui:
		dialog_ui.start_dialog(interactable.dialog)

	# Execute immediate actions if needed
	if interactable.actions:
		for action in interactable.actions:
			GameEvents.execute_action(action)


func on_dialog_started() -> void:
	can_interact = false


func on_dialog_ended() -> void:
	can_interact = true
