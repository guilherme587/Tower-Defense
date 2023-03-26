extends StaticBody2D

export var base 	:PackedScene	= preload("res://cenas/tower_1_base.tscn")
export var shot 	:PackedScene	= preload("res://cenas/fire.tscn")

var targets 		:Array 			= []
var target 			:Object			= null
var shotInstance	:Object			= null
var baseInstance 	:Object			= base.instance()

var cooldown		:float			= .7
var can_shot 		:bool 			= true
var in_area			:bool 			= false
var money			:int			= 250

func _ready():
	get_parent().get_parent().get_parent().add_child(baseInstance)
	
	shotInstance 					= shot.instance()
	shotInstance.global_position 	= $Position2D.global_position
	shotInstance.scale				= Vector2(2, 2)
	get_parent().add_child(shotInstance)
	Game.money -= money

func _physics_process(_delta):
	baseInstance.global_position = self.global_position
	
	if targets.size() > 0:
		if in_area:
			look_at(targets[0].global_position)
		if can_shot:
			shot()


func shot():
	shotInstance.global_position = $Position2D.global_position
	shotInstance.rotation			= Vector2( cos(global_rotation + 45), sin(global_rotation + 45) ).normalized().angle() 


func _on_Area2D_body_entered(body):
	targets.append(body)
	can_shot 		= true
	in_area 		= true


func _on_Area2D_body_exited(body):
	targets.remove(targets.find(body))
	can_shot			 	= false
	in_area 				= false


func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.button_mask == 1:
		print("mosntra")
#	if event is InputEventMouseButton and event.button_mask == 0:
#		print("esconde")
