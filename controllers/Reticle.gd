extends CenterContainer
#setting variable for the crosshair
@export var DOT_RADIUS : float =1.0
@export var DOT_COLOR : Color = Color.BLACK
@export var RETICLE_LINES : Array[Line2D]
@export var RETICLE_SPEED : float = 0.25# how quickly lines change
@export var RETICLE_DISTANCE : float = 2.0# how far the lines move
@export var PLAYER_CONTROLLER : CharacterBody3D
# Called when the node enters the scene tree for the first time.
func _ready():
	queue_redraw()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _draw():
	draw_circle(Vector2(0,0),DOT_RADIUS,DOT_COLOR)#draws it using position
