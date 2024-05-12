class_name SlidingPlayerState extends PlayerMovementState

@export var SPEED: float = 6.0
@export var ACCELERATION : float = 0.1
@export var DECELERATION : float = 0.25
@export var TILT_AMOUNT : float = 0.09
@export_range(1, 6, 0.1) var SLIDE_ANIM_SPEED : float = 4.0

@onready var CROUCH_SHAPECAST : ShapeCast3D = %ShapeCast3D
#will get the sliding animation and play 
func enter(previous_state) -> void:#check the state were coming from
	set_tilt(PLAYER._current_rotation)
	ANIMATION.get_animation("Sliding").track_set_key_value(4,0,PLAYER.velocity.length())
	ANIMATION.speed_scale = 1.0 # force a reset of speed scale
	ANIMATION.play("Sliding", -1.0, SLIDE_ANIM_SPEED)

func update(delta):
	PLAYER.update_gravity(delta)
#	PLAYER.update_input(SPEED,ACCELERATION,DECELERATION) # Disable to maintain direction while sliding
	PLAYER.update_velocity()
	# this is just something I put in all my states
	
# rotates the player in the horizantal direction a bit so it looks like your really sliding
func set_tilt(player_rotation) -> void:
	var tilt = Vector3.ZERO#tilt is set to 0
	#amount of tilt depands on amount of rotation
	tilt.z = clamp(TILT_AMOUNT * player_rotation, -0.1, 0.1)#z value of our vector equal to our base tilt amount * player roation and clamped betweem the other numbers
	if tilt.z == 0.0:#
		tilt.z = 0.05
	ANIMATION.get_animation("Sliding").track_set_key_value(7,1,tilt)#adjusting keyframes using tilt value
	ANIMATION.get_animation("Sliding").track_set_key_value(7,2,tilt)
	#to find the track index with an index number to print and check
	print(ANIMATION.get_animation("Sliding").track_get_path(7))
		
func finish():# will run when our animation finishes
	transition.emit("CrouchingPlayerState")
