class_name Idle
extends State

@onready var player = $"../.."

# Called when the node enters the scene tree for the first time.
func Physics_Update(_delta: float):
	if player.velocity.x != 0 or player.velocity.z != 0  :
		Transitioned.emit(self , "Walk")
		
	if not player.is_on_floor():
		Transitioned.emit(self , "Jump")
