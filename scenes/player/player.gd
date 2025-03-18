extends CharacterBody3D
class_name Player


@export var facing_left := false


const SPEED = 5.0


@onready var visuals: Node3D = $Visuals
@onready var camera_controller: Node3D = $CameraController
#@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	visuals.scale.x = -1.0 if facing_left else 1.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
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


func handle_camera():
	camera_controller.position = lerp(camera_controller.position, position, 0.15)
