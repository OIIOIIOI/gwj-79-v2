extends StaticBody3D
class_name Well


@export var tree_small: Texture2D
@export var tree_medium: Texture2D
@export var tree_big: Texture2D

@onready var tree_sprite: Sprite3D = $TreeSprite
@onready var object_drop_sfx: AudioStreamPlayer3D = $ObjectDropSFX
@onready var tree_sfx: AudioStreamPlayer3D = $TreeSFX
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	GameEvents.step_added.connect(on_step_added)


func on_step_added(step: GameEnums.STEPS) -> void:
	match step:
		GameEnums.STEPS.Step_DroppedSeed:
			react_to_drop()
			await get_tree().create_timer(3.0).timeout
			animation_player.play(&"appear")
			grow_tree(tree_small)
		GameEnums.STEPS.Step_DroppedWeapon:
			react_to_drop()
			grow_tree(tree_medium)
		GameEnums.STEPS.Step_DroppedEmerald:
			react_to_drop()
			grow_tree(tree_big)
		GameEnums.STEPS.Step_DroppedBook:
			react_to_drop()


func react_to_drop() -> void:
	object_drop_sfx.play()
	await get_tree().create_timer(2.0).timeout
	tree_sfx.play()


func grow_tree(texture: Texture2D) -> void:
	tree_sprite.texture = texture
	tree_sprite.offset.x = -texture.get_size().x * 0.5
