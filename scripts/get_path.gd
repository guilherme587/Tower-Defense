extends KinematicBody2D

var navigation_path				:Navigation2D	= null
var path 						:Array 			= []
var velocity 					:Vector2 		= Vector2.ZERO
var end 						:Vector2		= Vector2.ZERO
var speed						:int			= 150

signal can_draw_path

func _ready():
	self.visible = false
	navigation_path = get_parent().get_parent()


func _physics_process(_delta):
	if end and navigation_path:
		generate_path()
		navigate()
	
	move_and_slide(velocity)
	
	if path.size() > 0:
		emit_signal("can_draw_path")


func generate_path():
	if end != Vector2.ZERO and navigation_path != null:
		path = navigation_path.get_simple_path(self.global_position, end, false)


func navigate():
	if path.size() > 0:
		velocity = self.global_position.direction_to(path[1]) * speed
