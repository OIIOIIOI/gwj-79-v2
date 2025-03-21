extends CharacterBody3D
class_name Player


@export var facing_left := false
@export var can_move := true


const SPEED = 2.0


@onready var visuals: Node3D = $Visuals
@onready var camera_controller: Node3D = $CameraController
@onready var footsteps_sfx: AudioStreamPlayer = $SFX/Footsteps/FootstepsSFX
@onready var footsteps_timer: Timer = $SFX/Footsteps/FootstepsTimer
#@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	visuals.scale.x = -1.0 if facing_left else 1.0

	footsteps_timer.timeout.connect(on_footsteps_timer_timeout)
	footsteps_sfx.volume_db = linear_to_db(0.5)

	GameEvents.dialog_started.connect(on_dialog_started)
	GameEvents.dialog_ended.connect(on_dialog_ended)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get input direction
	var input_dir := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	if !can_move:
		input_dir = Vector2.ZERO

	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		#animation_player.play(&"walk")
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		#animation_player.play(&"idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if direction.x < -0.05:
		visuals.scale.x = -1.0
	elif direction.x > 0.05:
		visuals.scale.x = 1.0

	move_and_slide()
	handle_camera()

	if velocity.length_squared() > 0.0:
		# Start footsteps SFX timer
		if footsteps_timer.is_stopped():
			footsteps_timer.start(0.05)
	else:
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
