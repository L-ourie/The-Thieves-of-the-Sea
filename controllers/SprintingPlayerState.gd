class_name SprintingPlayerState extends PlayerMovementState

@export var SPEED: float = 6.0
@export var ACCELERATION : float = 0.1
@export var DECELERATION : float = 0.25
@export var TOP_ANIM_SPEED : float = 1.6

func enter(previous_state) -> void:
	if ANIMATION.is_playing() and ANIMATION.current_animation == "JumpEnd":# if the animation is our jump ending
		await ANIMATION.animation_finished	#lets it finsih the jump ending	
		ANIMATION.play("Sprinting",0.5,1.0)
		#plays the animation
	else:
		ANIMATION.play("Sprinting",0.5,1.0)

#resets the speed
func exit() -> void:
	ANIMATION.speed_scale = 1.0

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DECELERATION)
	PLAYER.update_velocity()
	
	set_animation_speed(PLAYER.velocity.length())
	#check if your no longer sprinting
	if Input.is_action_just_released("sprint") or PLAYER.velocity.length() == 0:
		transition.emit("IdlePlayerState")
		#check if you can slide and if u have enough speed to be able to
	if Input.is_action_just_pressed("crouch") and PLAYER.velocity.length() > 6:
		transition.emit("SlidingPlayerState")
# does the animation speed
	if Input.is_action_just_pressed("jump") and PLAYER.is_on_floor():
		transition.emit("JumpingPlayerState")

	if PLAYER.velocity.y < -3.0 and !PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")#check if your falling

func set_animation_speed(spd) -> void:
	var alpha = remap(spd, 0.0, SPEED, 0.0, 1.0)
	ANIMATION.speed_scale = lerp(0.0, TOP_ANIM_SPEED, alpha)
