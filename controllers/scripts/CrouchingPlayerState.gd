class_name CrouchingPlayerState extends PlayerMovementState
#sets variables
@export var SPEED: float = 2.0
@export var ACCELERATION : float = 0.1
@export var DECELERATION : float = 0.25
@export_range(1, 6, 0.1) var CROUCH_SPEED : float = 4.0

@onready var CROUCH_SHAPECAST : ShapeCast3D = %ShapeCast3D
# see if you released it
var RELEASED : bool = false

func enter(previous_state) -> void:
	#resets speed
	ANIMATION.speed_scale = 1.0
	#if your not sliding and you press the crouch button crouch
	if previous_state.name != "SlidingPlayerState":
		ANIMATION.play("Crouching", -1.0, CROUCH_SPEED)
	elif previous_state.name == "SlidingPlayerState":
		ANIMATION.current_animation = "Crouching"
		ANIMATION.seek(1.0, true)
		
func exit() -> void:
	RELEASED = false

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DECELERATION)
	PLAYER.update_velocity()
	#uncrouches you when you release the button
	if Input.is_action_just_released("crouch"):
		uncrouch()
	#another thing to see if you uncrouch
	elif Input.is_action_pressed("crouch") == false and RELEASED == false:
		RELEASED = true
		uncrouch()

	if Input.is_action_just_pressed("jump") and PLAYER.is_on_floor():
		transition.emit("JumpingPlayerState")

#check if your no longer crouching
func uncrouch():
	#checks to see if somethings above you when your uncrouching
	if CROUCH_SHAPECAST.is_colliding() == false:
		ANIMATION.play("Crouching", -1.0 ,-CROUCH_SPEED, true)
		await ANIMATION.animation_finished
		if PLAYER.velocity.length() == 0:
			transition.emit("IdlePlayerState")
		else:
			transition.emit("WalkingPlayerState")
	elif CROUCH_SHAPECAST.is_colliding() == true:
		await get_tree().create_timer(0.1).timeout
		uncrouch()
