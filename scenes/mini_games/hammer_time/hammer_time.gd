extends Node2D
class_name HammerTime


const nail_scene: PackedScene = preload("res://scenes/mini_games/hammer_time/nail.tscn")

const MAX_NAILS := 3

enum GAME_STATE {
	Initializing,
	HandMoving,
	NailReleased,
	HandSafe,
	NailFallen,
	End,
}


var game_state: GAME_STATE = GAME_STATE.Initializing
var current_nail := 0
var current_nail_instance: Nail
var reset_weapon_position := Vector2.ZERO
var reset_hand_position := Vector2.ZERO
var target_hand_position := Vector2.ZERO
var running_tweens: Array[Tween] = []
var can_hit := false


@onready var weapon: Weapon = $Weapon
@onready var nail_hand: NailHand = $NailHand
@onready var nails_container: Node2D = $Nails
@onready var nail_fall_timer: Timer = $NailFallTimer
@onready var hand_safe_timer: Timer = $HandSafeTimer
@onready var win_sfx: AudioStreamPlayer = $WinSFX
@onready var hit_success_sfx: AudioStreamPlayer = $HitSuccessSFX
@onready var hit_fail_sfx: AudioStreamPlayer = $HitFailSFX
@onready var hit_hand_sfx: AudioStreamPlayer = $HitHandSFX


func _ready() -> void:
	nail_fall_timer.timeout.connect(on_nail_fall_timer_timeout)
	hand_safe_timer.timeout.connect(on_hand_safe_timer_timeout)

	nail_hand.visible = false

	var screen_width := get_viewport().get_visible_rect().size.x
	reset_hand_position = Vector2(screen_width / 2 + 20.0, nails_container.global_position.y)

	reset_weapon_position = weapon.global_position

	var tween = weapon.intro()

	running_tweens.push_back(tween)
	await tween.finished
	running_tweens.erase(tween)

	set_target_and_move()


func set_target_and_move() -> void:
	var screen_width := get_viewport().get_visible_rect().size.x
	var target_x = (current_nail + 1) * (screen_width / (MAX_NAILS + 1)) - screen_width / 2
	target_hand_position = Vector2(target_x, nails_container.global_position.y)

	nail_hand.global_position = reset_hand_position
	nail_hand.show_nail()
	nail_hand.visible = true
	current_nail_instance = null
	can_hit = true

	game_state = GAME_STATE.HandMoving

	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(nail_hand, ^"position", target_hand_position, float(randi_range(2, 4)))

	running_tweens.push_back(tween)
	await tween.finished
	running_tweens.erase(tween)

	release_nail()


func release_nail() -> void:
	current_nail_instance = spawn_nail_at_hand_position()

	target_hand_position.x += 50.0

	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(nail_hand, ^"position", target_hand_position, 0.5)

	running_tweens.push_back(tween)
	await tween.finished
	running_tweens.erase(tween)

	game_state = GAME_STATE.NailReleased

	nail_fall_timer.start(3.0)
	hand_safe_timer.start(randf_range(1.5, 2.5))


func spawn_nail_at_hand_position() -> Nail:
	current_nail_instance = nail_scene.instantiate() as Nail
	nails_container.add_child(current_nail_instance)
	current_nail_instance.global_position = nail_hand.position

	nail_hand.hide_nail()

	return current_nail_instance


func on_hand_safe_timer_timeout() -> void:
	game_state = GAME_STATE.HandSafe

	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(nail_hand, ^"position", reset_hand_position, 1.0)

	running_tweens.push_back(tween)
	await tween.finished
	running_tweens.erase(tween)


func on_nail_fall_timer_timeout() -> void:
	game_state = GAME_STATE.NailFallen

	current_nail_instance.fall()
	await current_nail_instance.tree_exited

	set_target_and_move()


func _process(_delta: float) -> void:
	# TODO Remove this
	# Handle cheat
	if game_state != GAME_STATE.Initializing && game_state != GAME_STATE.End:
		if Input.is_action_just_pressed(&"open_book"):
			end_game()

	# Handle action
	if game_state == GAME_STATE.HandMoving || game_state == GAME_STATE.NailReleased || game_state == GAME_STATE.HandSafe:
		if Input.is_action_just_pressed(&"action") && can_hit:
			hit()


func stop_everything() -> void:
	nail_fall_timer.stop()
	hand_safe_timer.stop()

	for tween in running_tweens:
		tween.kill()


func hit() -> void:
	# Fail
	if game_state == GAME_STATE.HandMoving || game_state == GAME_STATE.NailReleased:
		hit_fail()
	# Success
	elif game_state == GAME_STATE.HandSafe:
		hit_success()


func hit_fail() -> void:
	# Stop timers and tweens
	stop_everything()
	can_hit = false

	# Anim weapon
	weapon.global_position.x = reset_weapon_position.x + nail_hand.global_position.x
	weapon.hit()

	# Play SFX
	hit_fail_sfx.play()
	await get_tree().create_timer(0.15, false).timeout
	hit_hand_sfx.play()

	# Make nail fall
	if !current_nail_instance:
		current_nail_instance = spawn_nail_at_hand_position()
	current_nail_instance.fall()

	# Remove hand
	nail_hand.hit()
	await get_tree().create_timer(0.1, false).timeout

	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(nail_hand, ^"position", reset_hand_position, 0.5)

	running_tweens.push_back(tween)
	await tween.finished
	running_tweens.erase(tween)

	await get_tree().create_timer(1.0, false).timeout

	set_target_and_move()


func hit_success() -> void:
	nail_fall_timer.stop()
	can_hit = false

	var nailed: float = current_nail_instance.hit()

	# Anim weapon
	weapon.global_position.x = reset_weapon_position.x + current_nail_instance.global_position.x
	weapon.hit(nailed)

	hit_success_sfx.play()
	await hit_success_sfx.finished

	if nailed == 1.0:
		current_nail += 1
		if current_nail < MAX_NAILS:
			set_target_and_move()
		else:
			end_game()
	else:
		can_hit = true


func end_game() -> void:
	game_state = GAME_STATE.End

	stop_everything()

	win_sfx.play()
	await win_sfx.finished

	# Trigger end action
	var end_action = AddStepAction.new()
	end_action.step = GameEnums.STEPS.Step_ObtainedWeapon
	GameEvents.execute_action(end_action)

	SceneTransition.transition_to(GameEnums.SCENES.Scene_Main)
