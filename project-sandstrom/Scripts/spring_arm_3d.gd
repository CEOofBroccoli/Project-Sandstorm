extends SpringArm3D

@export var mouse_speed : float = 0.005
var mouse_captured : bool = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event : InputEvent):
	if event is InputEventMouseMotion and mouse_captured == true:
		rotation.y -= event.relative.x * mouse_speed
		rotation.y = wrapf(rotation.y, 0.0 , TAU)
		
		rotation.x -= event.relative.y * mouse_speed
		rotation.x = clamp(rotation.x, -PI/2 , PI/4)
		
	if Input.is_action_just_pressed("menu") :
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			release_mouse()
		else:
			capture_mouse()
	if Input.is_action_just_pressed("exit") :
		get_tree().quit() # kys func 

	

func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true


func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false
	
	
