extends Label

@onready var player = %Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	self.text = " Velocity: %s\n Pos: %s \n State: %s  \n Dash: %s" % [
		player.velocity , 
		player.global_position ,
		player.current_state() ,
		player.dash_timer
		
	]
