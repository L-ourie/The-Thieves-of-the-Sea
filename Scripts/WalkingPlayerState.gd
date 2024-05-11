class_name WalkingPlayerState

extends State

@export var ANIMATION : AnimationPlayer
@export var TOP_ANIM_SPEED : float = 2.2
func enter() -> void:
	ANIMATION.play("Walking",-1.0,1.0)#plays the camera animation
	Global.player._speed = Global.player.SPEED_DEFAULT

func update(delta):
	set_animation_speed(Global.player.velocity.length())
	if Global.player.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")# Will call on transition function in state machine

#sets the speed scale of our animation player to a lerp from 0 to our top animation speed bases on a alpha value between 0 and 1
func set_animation_speed(spd):
	var alpha = remap(spd,0.0,Global.player.SPEED_DEFAULT,0.0,1.0)
	ANIMATION.speed_scale = lerp(0.0,TOP_ANIM_SPEED,alpha)
#when we accelerate were going to accelerate our animation speed faster

func _input(event):#check if we pressed our sprint if we do we transition to sprin
	if event.is_action_pressed("sprint") and Global.player.is_on_floor():
		transition.emit("SprintingPlayerState")
