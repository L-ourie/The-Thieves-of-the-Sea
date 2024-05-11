class_name State# class name let you reference the script easily

extends Node

signal transition(new_state_name:StringName)#used to communicate between scripts
#four functions to hanlde transtion to different states

func enter() ->void:
	pass

func exit() ->void:
	pass

func update(delta: float) ->void:#procces function
	pass
	
func physics_update(delta:float)-> void:#physics process
	pass
	


