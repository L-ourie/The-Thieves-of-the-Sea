class_name JumpingPlayerState extends PlayerMovementState
#setting variables
@export var SPEED: float = 6.0
@export var ACCELERATION : float = 0.1
@export var DECELERATION : float = 0.25
@export var JUMP_VELOCITY : float = 4.5
#contorls jump velocity force
#double jump velocity
@export var DOUBLE_JUMP_VELOCITY : float = 5.5
@export_range(0.5, 1.0, 0.01) var INPUT_MULTIPLIER : float = 0.85
#contorls input amount into the air
#see if you can double jump
var DOUBLE_JUMP : bool = false

#runs when we enter our state
func enter(previous_state) -> void:
	PLAYER.velocity.y += JUMP_VELOCITY#gives a upward push
	ANIMATION.play("JumpStart")# plays the jump animation

func exit() -> void:
	DOUBLE_JUMP = false
	#resets the double jump
func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED * INPUT_MULTIPLIER,ACCELERATION,DECELERATION)
	PLAYER.update_velocity()
	
	if Input.is_action_just_pressed("jump") and DOUBLE_JUMP == false:#checks if the player has alrealdy double jumped
		DOUBLE_JUMP = true
		PLAYER.velocity.y = DOUBLE_JUMP_VELOCITY#set it to the player velocity/ always equal that value
	
	#check to make sure you arent alrealy falling downward then make the velocity / 2
	if Input.is_action_just_released("jump"):
		if PLAYER.velocity.y > 0:
			PLAYER.velocity.y = PLAYER.velocity.y/2.0
		
	#checks if character should go back to idle
	if PLAYER.is_on_floor():
		ANIMATION.play("JumpEnd")#plays the jump animation
		
		transition.emit("IdlePlayerState")
