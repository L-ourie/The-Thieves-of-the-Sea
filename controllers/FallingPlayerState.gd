class_name FallingPlayerState extends PlayerMovementState

@export var SPEED: float = 6.0
@export var ACCELERATION : float = 0.1
@export var DECELERATION : float = 0.25
#double jump velocity
@export var DOUBLE_JUMP_VELOCITY : float = 5.5

#see if you can double jump
var DOUBLE_JUMP : bool = false

func enter(previous_state) -> void:
	ANIMATION.pause()

func exit() -> void:
	DOUBLE_JUMP = false
	#resets the double jump

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DECELERATION)
	PLAYER.update_velocity()
	
	if Input.is_action_just_pressed("jump") and DOUBLE_JUMP == false:#checks if the player has alrealdy double jumped
		DOUBLE_JUMP = true
		PLAYER.velocity.y = DOUBLE_JUMP_VELOCITY#set it to the player velocity/ always equal that value
	
	#check to make sure you arent alrealy falling downward then make the velocity / 2
		
	#checks if character should go back to idle
	if PLAYER.is_on_floor():
		ANIMATION.play("JumpEnd")#plays the jump animation
		
		transition.emit("IdlePlayerState")
