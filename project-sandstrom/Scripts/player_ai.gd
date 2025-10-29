class_name CharacterController
extends CharacterBody3D

@export_group("Rules")
@export var can_move: bool = true
@export var has_gravity: bool = true
@export var can_dash: bool = true
@export var can_doubledash: bool = true
@export var can_sidestep: bool = true

@export_group("Speeds")
@export var look_speed: float = 0.002
@export var move_speed: float = 5.0
@export var gravity_acceleration: float = 9.8  # Standard gravity scale
@export var dash_velocity: float = 20.0       # Higher for snappy dash
@export var sidestep_velocity: float = 10.0
@export var air_control: float = 0.5          # Reduce air movement

@onready var camera_3d = %Camera3D
@onready var collision_shape = $CollisionShape3D

var is_dashing: bool = false
var dash_cooldown: float = 0.0
var dash_cooldown_time: float = 0.5  # Seconds before next dash

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Rotate character horizontally based on mouse
		rotate_y(-event.relative.x * look_speed)

func _physics_process(delta: float) -> void:
	var current_speed = move_speed
	
	# Handle gravity
	if not is_on_floor():
		velocity.y -= gravity_acceleration * delta
		current_speed *= air_control

	# Handle dashing
	if can_dash and Input.is_action_just_pressed("dash") and dash_cooldown <= 0:
		_start_dash(delta)

	# Decrement dash cooldown
	dash_cooldown = max(0, dash_cooldown - delta)

	# Handle movement
	if can_move:
		var input_dir = Input.get_vector("left", "right", "forward", "backward")
		var direction = Vector3.ZERO

		if input_dir != Vector2.ZERO:
			# Get forward and right vectors relative to character's rotation (Y only)
			var forward = -transform.basis.z
			var right = transform.basis.x
			forward.y = 0
			right.y = 0
			forward = forward.normalized()
			right = right.normalized()

			direction = forward * input_dir.y + right * input_dir.x
			direction = direction.normalized()

			velocity.x = direction.x * current_speed
			velocity.z = direction.z * current_speed
		else:
			# Smooth deceleration
			var decel = move_speed * 2  # Tune this value
			velocity.x = move_toward(velocity.x, 0, decel * delta)
			velocity.z = move_toward(velocity.z, 0, decel * delta)

	move_and_slide()

# --- Dash Logic ---
func _start_dash(delta: float) -> void:
	if not camera_3d:
		return

	# Get camera forward direction (projected onto XZ plane)
	var cam_forward = -camera_3d.global_transform.basis.z
	cam_forward.y = 0
	cam_forward = cam_forward.normalized()

	if cam_forward.length() < 0.1:
		cam_forward = -transform.basis.z
		cam_forward.y = 0
		cam_forward = cam_forward.normalized()

	# Apply dash impulse
	velocity += cam_forward * dash_velocity
	is_dashing = true
	dash_cooldown = dash_cooldown_time

	# Optional: play sound
	# dash_sound.play()
	print("Dashed in direction:", cam_forward)
