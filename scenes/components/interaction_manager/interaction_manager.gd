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


#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed(&"action"):
		#print("InteractionManager _unhandled_input")
	#if can_interact && event.is_action_pressed(&"action"):
		#get_viewport().set_input_as_handled()
		#activate_closest_interactable()


func activate_closest_interactable() -> void:
	var all_active := get_active_interactables()
	#print("Found ", all_active.size(), " interactables")
	var closest := get_closest_interactable(all_active)
	if closest:
		print("Closest: ", closest.name)
		activate_interactable(closest)


func get_active_interactables() -> Array[InteractionComponent]:
	var active_interactables: Array[InteractionComponent] = []

	var interactables = get_tree().get_nodes_in_group(&"interactables")
	for interactable in interactables:
		if interactable is InteractionComponent:
			if interactable.is_in_range:
				active_interactables.append(interactable)

	return active_interactables


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
	#print("Activating ", interactable.name)
	if interactable.dialog && dialog_ui:
		dialog_ui.start_dialog(interactable.dialog)

	if interactable.actions:
		for action in interactable.actions:
			execute_action(action)


func execute_action(action:GameAction) -> void:
	match action:
		_:
			print(action.name, ": ", action.value)


func on_dialog_started() -> void:
	can_interact = false


func on_dialog_ended() -> void:
	can_interact = true
