class_name IdlePlayerState

extends State
#WILL CHECK IF PLAYER HAS VELOCITY
func upadate(delta):
	if Global.player.velocity.length()> 0.0:
		transition.emit("WalkingPlayerState")# Will call on transition function in state machine
