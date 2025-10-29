class_name CharacterControler
extends CharacterBody3D

@export_group("Rules")
@export var can_move : bool = true
@export var has_gravity : bool = true
@export var can_dash : bool = true
@export var can_doubledash : bool = true
@export var can_sidestep : bool = true

@export_group("Speeds")
@export var look_speed : float = 0.002
@export var move_speed : float = 5
@export var gravity_speed : float = 1.0
@export var dash_velocity : float = 4.5
@export var sidestep_velocity : float = 10


@onready var camera_3d = %Camera3D
@onready var collision_3d = $CollisionShape3D
#@onready var dash_sound = $"Ultrakill DashSound"

var look_rotation : Vector3
var input_directions : Vector2
var move_directions : Vector3

##collision check
#func _on_body_entered(body):
	#if body.collision_mask & 4:  # checks if layer 3 (value 4) is set
		#var collisoned = int(body.collision_layer)
		#print("Hit something on mask " + collisoned)

func _physics_process(delta: float) -> void:
	if not is_on_floor() and has_gravity:
		velocity += get_gravity() * gravity_speed * delta
	#if can_dash and Input.is_action_just_pressed("dash"): ## add a full can_dash_check function
		#if is_on_floor():
			#var look_dir = - camera_3d.get_global_rotation()
			#print(look_dir)
#
			#velocity += look_dir.normalized() * dash_velocity * 2
			#print("dash")
			##dash_sound.play()
	#
	input_directions = Input.get_vector("left", "right", "forward", "backward")
	move_directions = (transform.basis * Vector3(input_directions.x, 0, input_directions.y)).normalized() ## make it 3D
	if move_directions:
		velocity.x = move_directions.x * move_speed
		velocity.z = move_directions.z * move_speed
		
	move_and_slide()


func dash() -> void:
	pass

#func disable_gravity() -> void:
#	has_gravity == false

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
