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


@onready var camera = %Camera3D
@onready var collision_3d = $CollisionShape3D
@onready var state_machine = %"State Machine"


var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var look_rotation : Vector3
var input_directions : Vector2
var move_directions : Vector3
var direction 

##collision check
#func _on_body_entered(body):
	#if body.collision_mask & 4:  # checks if layer 3 (value 4) is set
		#var collisoned = int(body.collision_layer)
		#print("Hit something on mask " + collisoned)

func _process(delta: float) -> void:

	velocity += get_gravity() 
	
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
	move_and_slide()


func current_state() :
	return state_machine.current_state.name

func jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += 30

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
