extends StaticBody3D
class_name Well


signal drop_sequence_complete


@export var tree_small: Texture2D
@export var tree_medium: Texture2D
@export var tree_big: Texture2D


@onready var tree_sprite: Sprite3D = $TreeSprite
@onready var object_drop_sfx: AudioStreamPlayer = $ObjectDropSFX
@onready var tree_sfx: AudioStreamPlayer = $TreeSFX
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	GameEvents.step_added.connect(on_step_added)


func on_step_added(step: GameEnums.STEPS) -> void:
	match step:
		GameEnums.STEPS.Step_DroppedSeed:
			drop_sequence()
			await drop_sequence_complete
			# Update tree sprite
			grow_tree(tree_small)
			# Play appear animation
			animation_player.play(&"appear")
			# Wait until the end of the tree growing SFX and emit grown signal
			await tree_sfx.finished
			GameEvents.tree_grown.emit()

		GameEnums.STEPS.Step_DroppedWeapon:
			drop_sequence()
			await drop_sequence_complete
			# Update tree sprite
			grow_tree(tree_medium)
			# Wait until the end of the tree growing SFX and emit grown signal
			await tree_sfx.finished
			GameEvents.tree_grown.emit()

		GameEnums.STEPS.Step_DroppedEmerald:
			drop_sequence()
			await drop_sequence_complete
			# Update tree sprite
			grow_tree(tree_big)
			# Wait until the end of the tree growing SFX and emit grown signal
			await tree_sfx.finished
			GameEvents.tree_grown.emit()

		GameEnums.STEPS.Step_DroppedBook:
			drop_sequence()
			# Wait until the end of the tree growing SFX and emit grown signal
			await tree_sfx.finished
			GameEvents.tree_grown.emit()


func drop_sequence() -> void:
	# Play drop SFX
	object_drop_sfx.play()
	# Wait some time and play tree growing SFX
	await get_tree().create_timer(3.0).timeout
	tree_sfx.play()
	# Wait some time into the growing tree SFX
	await get_tree().create_timer(2.0).timeout
	drop_sequence_complete.emit()


func grow_tree(texture: Texture2D) -> void:
	tree_sprite.texture = texture
	tree_sprite.offset.x = -texture.get_size().x * 0.5
