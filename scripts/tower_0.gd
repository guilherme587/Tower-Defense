extends StaticBody2D

export var base 	:PackedScene	= preload("res://cenas/tower_0_base.tscn")
export var shot 	:PackedScene	= preload("res://cenas/shot.tscn")

var targets 		:Array 			= []
var target 			:Object			= null
var baseInstance 	:Object			= base.instance()

var cooldown		:float			= .7
var can_shot 		:bool 			= true
var in_area			:bool 			= false
var money			:int			= 250

func _ready():
	get_parent().get_parent().get_parent().add_child(baseInstance)
	
	Game.money -= money

func _physics_process(_delta):
	baseInstance.global_position = self.global_position
	
	if targets.size() > 0:
		if in_area:
			look_at(targets[0].global_position)
		if can_shot:
			shot()


func shot():
	var shotInstance = shot.instance()
	shotInstance.global_position = $Position2D.global_position
	shotInstance.dir = Vector2( cos(self.global_rotation), sin(self.global_rotation) ).normalized()
	get_parent().add_child(shotInstance)
	shotInstance.posi_init = self
	
	can_shot = false
	yield(get_tree().create_timer(cooldown), "timeout")
	can_shot = true


func _on_Area2D_body_entered(body):
	targets.append(body)
	in_area = true


func _on_Area2D_body_exited(body):
	targets.remove(targets.find(body))
	in_area = false


func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.button_mask == 1:
		print("mosntra")
#	if event is InputEventMouseButton and event.button_mask == 0:
#		print("esconde")
