extends CPUParticles2D

var target			:Object			= null
onready var ray		:Area2D			= $Area2D
var damage			:float			= .5
var cooldown		:float			= 1.2
var can_attack		:bool			= true


func _ready():
	self.visible = false


func _physics_process(delta):
	hit(damage)

func hit(_damage):
	if can_attack:
		if is_instance_valid(target):
			if can_attack and target.has_method("hited"):
				target.hited(_damage)
				can_attack = false
				yield(get_tree().create_timer(cooldown), "timeout")
				can_attack = true


func _on_Area2D_body_entered(body):
	self.visible 	= true
	can_attack		= true
	target 			= body


func _on_Area2D_body_exited(body):
	self.visible 		= false
	can_attack 			= false
