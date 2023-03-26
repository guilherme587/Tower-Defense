extends KinematicBody2D

var navigation_path				:Navigation2D	= null
var path 						:Array 			= []
var velocity 					:Vector2 		= Vector2.ZERO
var end 						:Vector2		= Vector2.ZERO
var speed						:int			= 30
var life						:float			= 5
var money						:float			= 15
var damage						:float			= 1

func _ready():
	end				= get_parent().get_node("Navigation2D/TileMap").get_end()
	navigation_path = get_parent().get_node("Navigation2D")


func _physics_process(_delta):
	if end and navigation_path:
		generate_path()
		navigate()
	
	move_and_slide(velocity)


func generate_path():
	if end != Vector2.ZERO and navigation_path != null:
		path = navigation_path.get_simple_path(self.global_position, end, false)


func navigate():
	if path.size() > 0:
		velocity = self.global_position.direction_to(path[1]) * speed

func hited(dano):
	if life > 0:
		life -= dano
	if life <= 0:
		Game.money += money
		self.queue_free()
