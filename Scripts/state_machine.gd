class_name StateMachine

extends Node
@export var CURRENT_STATE: State
var states: Dictionary ={}# will hold any child of our state machine

func _ready():
	for child in get_children():#check if our child is in the state class/ if it has a state script attached
		if child is State:
			states[child.name] = child#add our child state to our state dictionarry
			child.transition.connect(on_child_transition)# connect signal from state script to the on child
		else:
			push_warning("State contatins bad child node")# warning if we find a node that isn't a state
	CURRENT_STATE.enter()#export
	
func _process(delta):# in our state script
	CURRENT_STATE.update(delta)
	
func _physics_process(delta):
	CURRENT_STATE.physics_update(delta)
	
func on_child_transition(new_state_name: StringName)-> void:#state name being passed as a parameter
	var new_state =states.get(new_state_name)#set a new state variable to the state that matches in our dicitonarry
	if new_state != null:# if we find the state
		if new_state != CURRENT_STATE:# we check if isn't the state were in currently
			CURRENT_STATE.exit()
			new_state.enter()
			CURRENT_STATE= new_state# make new state main state
	else:
		push_warning("state doesn't exist")
		
