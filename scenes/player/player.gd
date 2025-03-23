extends CharacterBody3D
class_name Player


const SPEED = 3.0


@export var facing_left := false
@export var can_move := true


var has_book := true
var is_book_open := false


@onready var visuals: Node3D = $Visuals
@onready var camera_controller: Node3D = $CameraController
@onready var footsteps_sfx: AudioStreamPlayer = $SFX/Footsteps/FootstepsSFX
@onready var footsteps_timer: Timer = $SFX/Footsteps/FootstepsTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	if GameData.latest_player_position !=  Vector3.ZERO:
		position = GameData.latest_player_position
		facing_left = GameData.latest_player_facing_left

	visuals.scale.x = -1.0 if facing_left else 1.0

	footsteps_timer.timeout.connect(on_footsteps_timer_timeout)
	footsteps_sfx.volume_db = linear_to_db(0.5)

	camera_controller.position = position

	GameEvents.dialog_started.connect(on_dialog_started)
	GameEvents.dialog_ended.connect(on_dialog_ended)
	GameEvents.step_added.connect(on_step_added)
	GameEvents.book_update_started.connect(on_book_update_started)
	GameEvents.book_update_finished.connect(on_book_update_finished)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get input direction
	var input_dir := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	if !can_move || is_book_open:
		input_dir = Vector2.ZERO

	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if direction.x < -0.05:
		visuals.scale.x = -1.0
		facing_left = true
	elif direction.x > 0.05:
		visuals.scale.x = 1.0
		facing_left = false

	move_and_slide()
	handle_camera()

	if velocity.length_squared() > 0.0:
		if !is_book_open:
			if has_book:
				animation_player.play(&"walk")
			else:
				animation_player.play(&"walk_no_book")
		# Start footsteps SFX timer
		if footsteps_timer.is_stopped():
			footsteps_timer.start(0.05)
	else:
		if !is_book_open:
			if has_book:
				animation_player.play(&"idle")
			else:
				animation_player.play(&"idle_no_book")
		# Stop footsteps SFX timer
		footsteps_timer.stop()


func handle_camera():
	camera_controller.position = lerp(camera_controller.position, position, 0.15)


func on_dialog_started() -> void:
	can_move = false


func on_dialog_ended() -> void:
	can_move = true


func on_footsteps_timer_timeout() -> void:
	if !footsteps_sfx.playing:
		footsteps_sfx.play()
	footsteps_timer.start(0.5)


func on_book_update_started() -> void:
	print("Player on_book_update_started")
	is_book_open = true
	animation_player.play(&"book")


func on_book_update_finished() -> void:
	print("Player on_book_update_finished")
	is_book_open = false


func on_step_added(step: GameEnums.STEPS) -> void:
	if step == GameEnums.STEPS.Step_DroppedBook:
		has_book = false
