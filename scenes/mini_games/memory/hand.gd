extends Area2D
class_name Hand


var current_drawer: Drawer


func _ready() -> void:
	area_entered.connect(on_area_entered)
	#area_exited.connect(on_area_exited)


func on_area_entered(area: Area2D) -> void:
	print("Entered ", area.name)
	if area is Drawer:
		current_drawer = area


func on_area_exited(area: Area2D) -> void:
	print("Exited ", area.name)
	if area is Drawer:
		current_drawer = null


func _process(delta: float) -> void:
	if Input.is_action_just_pressed(&"action"):
		print("ACTION")
		if current_drawer:
			current_drawer.toggle()
