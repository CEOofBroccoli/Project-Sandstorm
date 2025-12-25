class_name Idle
extends State


func Update(_delta: float):
	if player.velocity.x != 0 or player.velocity.z != 0 :
		Transitioned.emit(self , "Walk")
		
	elif not player.is_on_floor():
		Transitioned.emit(self , "Jump")
