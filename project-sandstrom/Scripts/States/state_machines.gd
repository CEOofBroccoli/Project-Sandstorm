extends Node


@export var initial_state : State 
@onready var player = $".."

var current_state : State
var states : Dictionary = {}

func _ready():
	# go throw the childer and add them to the state machine
	for child in get_children():
		if child is State:
			child.player = player
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_Transition)
	print(states)
	if initial_state :
		initial_state.Enter() 
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.Update(delta)

func _physics_process(delta):
	if current_state:
		#anim_player.play(current_state) # playing the animations 
		current_state.Physics_Update(delta)

func _input(event: InputEvent):
	if current_state:
		current_state.input_Update(event)

func on_child_Transition(state , new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		return
	
	print(str(state.name) + " --> " + str(new_state_name))
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	
	current_state = new_state
