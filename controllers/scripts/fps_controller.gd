class_name Player

extends CharacterBody3D
#setting variables
@export var MOUSE_SENSITIVITY : float = 0.5
@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0)
@export var CAMERA_CONTROLLER : Camera3D
@export var ANIMATIONPLAYER : AnimationPlayer
@export var CROUCH_SHAPECAST : ShapeCast3D

var _mouse_input : bool = false
var _rotation_input : float
var _tilt_input : float
var _mouse_rotation : Vector3
var _player_rotation : Vector3
var _camera_rotation : Vector3

var _current_rotation : float

# Get the gravity from the project settings to be synced with RigidBody nodes.

var gravity = 12

func _unhandled_input(event: InputEvent) -> void:
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		_tilt_input = -event.relative.y * MOUSE_SENSITIVITY

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
#setting up the camera so we can look around
func update_camera(delta) -> void:
	_current_rotation = _rotation_input
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta
	# set up the rotation of the mouse
	_player_rotation = Vector3(0.0,_mouse_rotation.y,0.0)
	_camera_rotation = Vector3(_mouse_rotation.x,0.0,0.0)

	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	global_transform.basis = Basis.from_euler(_player_rotation)
	
	CAMERA_CONTROLLER.rotation.z = 0.0
# for sliding, will tilt the camera where the player is going
	_rotation_input = 0.0
	_tilt_input = 0.0
	
func _ready():
	# making the global player this script
	Global.player = self
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	CROUCH_SHAPECAST.add_exception($".")
	#set fov so we can make it bigger when sliding
	CAMERA_CONTROLLER.fov = 75.0

func _physics_process(delta):
	# these are thing that pop up on the debug panel
	Global.debug.add_property("Velocity","%.2f" % velocity.length(), 2)
	Global.debug.add_property("ShapeCast", CROUCH_SHAPECAST.is_colliding(), 2)
	Global.debug.add_property("Collision Pos", $CollisionShape3D.position , 2)
	Global.debug.add_property("Mouse Rotation", _rotation_input, 2)
	
	update_camera(delta)
	#this is gravity
func update_gravity(delta) -> void:
	velocity.y -= gravity * delta
	#this is movement
func update_input(speed: float, acceleration: float, deceleration: float) -> void:
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = lerp(velocity.x,direction.x * speed, acceleration)
		velocity.z = lerp(velocity.z,direction.z * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.z = move_toward(velocity.z, 0, deceleration)
	#this is velocity
func update_velocity() -> void:
	move_and_slide()
