extends Node3D
class_name Village


@export var mayor_position: Marker3D
@export var keeper_position: Marker3D
@export var old_one_position: Marker3D
@export var boat_position: Marker3D


var mayor_scene: PackedScene = preload("res://scenes/npcs/mayor_ed.tscn")
var keeper_scene: PackedScene = preload("res://scenes/npcs/keeper.tscn")
var old_one_scene: PackedScene = preload("res://scenes/npcs/old_one.tscn")
var boat_scene: PackedScene = preload("res://scenes/buildings/boat.tscn")


@onready var npc_container: Node3D = $NPCs


func _ready() -> void:
	if GameData.has_step(GameEnums.STEPS.Step_ObtainedSeed):
		spawn_mayor()
	if GameData.has_step(GameEnums.STEPS.Step_ObtainedWeapon):
		spawn_keeper()
		spawn_boat()
	if GameData.has_step(GameEnums.STEPS.Step_ObtainedEmerald):
		spawn_old_one()


func spawn_mayor() -> void:
	var mayor_instance = mayor_scene.instantiate() as Node3D
	npc_container.add_child(mayor_instance)
	if mayor_position:
		mayor_instance.position = mayor_position.position


func spawn_keeper() -> void:
	var keeper_instance = keeper_scene.instantiate() as Node3D
	npc_container.add_child(keeper_instance)
	if keeper_position:
		keeper_instance.position = keeper_position.position


func spawn_old_one() -> void:
	var old_one_instance = old_one_scene.instantiate() as Node3D
	npc_container.add_child(old_one_instance)
	if old_one_position:
		old_one_instance.position = old_one_position.position


func spawn_boat() -> void:
	var boat_instance = boat_scene.instantiate() as Node3D
	npc_container.add_child(boat_instance)
	if boat_position:
		boat_instance.position = boat_position.position
