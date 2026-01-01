class_name Player
extends CharacterBody3D

@export_group("Rules")
@export var move : bool = true
@export var has_gravity : bool = true
@export var can_dash : bool = true
@export var sidestep : bool = true
@export var wallrun : bool = true
@export var walljump : bool = true

@export_group("Speeds")
@export var look_speed : float = 0.002
@export var move_speed : float = 10.0
@export var jump_speed : float = 10.0
@export var gravity_speed : float = 14.0
@export var dash_speed : float = 4.5
@export var sidestep_velocity : float = 10
@export var dash_cooldown : float = 1
@export var dash_timer : float = 0
@export var max_speed : float = 20
	

@onready var camera = %Camera3D
@onready var collision_3d = $CollisionShape3D
@onready var state_machine = %"State Machine"
@onready var camera_handler: SpringArm3D = $CameraHandler


var gravity: int = ProjectSettings.get_setting("physics/3d/default_gravity") 

var look_rotation : Vector3
var input_directions : Vector2
var move_directions : Vector3
var look_direction : Vector3


func _ready():
	dash_timer = dash_cooldown
	
func _physics_process(delta: float) -> void:
	velocity.x = clampf(velocity.x , -max_speed , max_speed)
	velocity.y = clampf(velocity.y , -max_speed , max_speed)
	velocity.z = clampf(velocity.z , -max_speed , max_speed)
	
	if is_on_floor():
		velocity.y = 0
		walljump = true
	elif is_on_wall():
		velocity.y -= gravity_speed * delta / 2 # friction
	else:
		velocity.y -= gravity_speed * delta 
	
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	direction = direction.rotated(Vector3.UP, camera.global_rotation.y)
	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)
	
	jump()
	dash(delta)
	move_and_slide()

func current_state() :
	return state_machine.current_state.name

func jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_speed
		# wall jumping 
	elif Input.is_action_just_pressed("jump") and is_on_wall() and walljump:
		var wall_normal = get_wall_normal()
		wall_normal.y = 0
		velocity = wall_normal * jump_speed * 6
		velocity.y += jump_speed
		walljump = false

func dash(delta: float) -> void:
	dash_timer = clampf(dash_timer , 0 , dash_cooldown)
	
	if dash_timer <= 0 :
		can_dash = true
	elif dash_timer > 0 and !can_dash:
		dash_timer -= delta 
	
	if Input.is_action_just_pressed("dash") and can_dash :
		var look_dir = -camera_handler.rotation.normalized()
		velocity = look_dir * dash_speed * 5
		can_dash = false
		dash_timer = dash_cooldown


		#look_dir = fposmod()
##double tap key
#const double_delay = 0.25
#var doubletap_time = double_delay
#var last_keycode = 0
#
#func _process(delta):
	#doubletap_time -= delta
	#
#func _input(event):
	#if event is InputEventKey and event.is_pressed():
		#if last_keycode == event.keycode and doubletap_time >= 0: 
			#print("DOUBLETAP: ", String.chr(event.keycode))
			#last_keycode = 0
		#else:
			#last_keycode = event.keycode
		#doubletap_time = double_delay 
