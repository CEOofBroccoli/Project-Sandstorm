class_name Jump
extends State


func Update(_delta: float):
	if player.is_on_floor():
		Transitioned.emit(self , "Idle")
