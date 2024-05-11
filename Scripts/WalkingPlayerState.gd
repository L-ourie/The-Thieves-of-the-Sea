class_name WalkingPlayerState

extends State

func upadate(delta):
	if Global.player.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")# Will call on transition function in state machine
