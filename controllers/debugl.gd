extends PanelContainer

@onready var property_container = %VBoxContainer

#var property
var frames_per_second : String

func _ready():
	visible = false#makes it invisble
	#prints the fps
	Global.debug = self # global reference to self in the global script
	# makes the variable in the global script = to this
func _process(delta):
	if visible:
		#uses delta time to get approx fps per second and to round two decimal place
		frames_per_second = "%.2f"%(1.0/delta) #gets fps every frame
		#property.text = property.name +": "+ frames_per_second
func _input(event):
	#toggle debug panel
	if event.is_action_pressed("debug"):
		visible = !visible
#debug function to add and update
func add_property(title: String,value, order):
	var target # will hold our new label node
	target = property_container.find_child(title,true,false)# try to find label node w same name
	if !target:#if there is no current label node for property ex. initial load
		target = Label.new()# creat new label node
		property_container.add_child(target)# add new node as child to Vbox
		target.name = title #set name to title
		target.text = target.name + ":" + str(value)#set text value
	elif visible:
		target.text = title + ":" + str(value) # update text value
		property_container.move_child(target,order)#Reorder property based on given order value

#function to add new debug property
#func add_debug_property(title:String,value):
	#property = Label.new()#creats new label
	#property_container.add_child(property)#add new node as child to vbox
	#property.name = title #set name to title
	#property.text = property.name +value
