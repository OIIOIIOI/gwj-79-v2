extends Node3D
class_name Village


@export var mayor_position: Marker3D
@export var keeper_position: Marker3D
@export var old_one_position: Marker3D
@export var boat_position: Marker3D
@export var cat_woman_position: Marker3D
@export var eli_position: Marker3D
@export var tv_guy_position: Marker3D


var mayor_scene: PackedScene = preload("res://scenes/npcs/mayor_ed.tscn")
var keeper_scene: PackedScene = preload("res://scenes/npcs/keeper.tscn")
var old_one_scene: PackedScene = preload("res://scenes/npcs/old_one.tscn")
var boat_scene: PackedScene = preload("res://scenes/buildings/boat.tscn")
var cat_woman_scene: PackedScene = preload("res://scenes/npcs/cat_woman.tscn")
var eli_scene: PackedScene = preload("res://scenes/npcs/eli.tscn")
var tv_guy_scene: PackedScene = preload("res://scenes/npcs/tv_guy.tscn")


@onready var npc_container: Node3D = $NPCs


func _ready() -> void:
	if GameData.has_step(GameEnums.STEPS.Step_ObtainedSeed):
		spawn_mayor()
		spawn_eli()
	if GameData.has_step(GameEnums.STEPS.Step_ObtainedWeapon):
		spawn_keeper()
		spawn_boat()
		spawn_cat_woman()
	if GameData.has_step(GameEnums.STEPS.Step_ObtainedEmerald):
		spawn_old_one()
		spawn_tv_guy()


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


func spawn_cat_woman() -> void:
	var npc_instance = cat_woman_scene.instantiate() as Node3D
	npc_container.add_child(npc_instance)
	if cat_woman_position:
		npc_instance.position = cat_woman_position.position


func spawn_eli() -> void:
	var npc_instance = eli_scene.instantiate() as Node3D
	npc_container.add_child(npc_instance)
	if eli_position:
		npc_instance.position = eli_position.position


func spawn_tv_guy() -> void:
	var npc_instance = tv_guy_scene.instantiate() as Node3D
	npc_container.add_child(npc_instance)
	if tv_guy_position:
		npc_instance.position = tv_guy_position.position
