extends Label

@onready var player = %Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	self.text = "Velocity: %s\nState: %s" % [player.velocity, player.current_state()]
