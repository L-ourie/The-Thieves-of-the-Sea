class_name IdlePlayerState

extends State
#WILL CHECK IF PLAYER HAS VELOCITY
@export var ANIMATION: AnimationPlayer

func enter() -> void:
	ANIMATION.pause()

func upadate(delta):
	if Global.player.velocity.length()> 0.0 and Global.player.is_on_floor():
		transition.emit("WalkingPlayerState")# Will call on transition function in state machine
