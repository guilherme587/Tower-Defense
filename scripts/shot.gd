extends Area2D

var dir = Vector2.ZERO
var vel :float = 350
var max_dist :float = 200
var dano :float = 1
var posi_init = Vector2.ZERO

func _physics_process(delta):
	if Global.dist_to(self, posi_init) >= max_dist:
		queue_free()
	translate(dir * delta * vel)


func set_dist_max(dist):
	max_dist = dist


func set_dano(_dano):
	dano = _dano


func _on_shot_body_entered(body):
	if body.is_in_group("enemy"):
		self.monitoring 			= false
		self.monitorable 			= false
		$CollisionShape2D.disabled 	= true
		body.hited(dano)
		self.queue_free()
