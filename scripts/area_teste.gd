extends Node2D

var enemy 				:Array		= [preload("res://cenas/enemy.tscn"),
										preload("res://cenas/enemy_snake.tscn"),
										preload("res://cenas/enemy_tart_boss.tscn")]
var can_spaw 			:bool 				= false
var cooldown			:float				= 1

func _ready():
	randomize()
	
	var enemyInstance 		:Object 		= enemy[2].instance()
	enemyInstance.global_position 			= get_node("Navigation2D/TileMap").get_start()
	add_child(enemyInstance)


func _process(_delta) -> void:
	if can_spaw:
		can_spaw = false
		yield(get_tree().create_timer(cooldown), "timeout")
		can_spaw = true
		
#		if randi() % 10000 <= 1:
#			var enemyInstance 		:Object 		= enemy[2].instance()
#			enemyInstance.global_position 			= get_node("Navigation2D/TileMap").get_start()
#			add_child(enemyInstance)
		
		var enemyNum			:int			= randi() % (enemy.size() - 1)
		var enemyInstance 		:Object 		= enemy[enemyNum].instance()
		enemyInstance.global_position 			= get_node("Navigation2D/TileMap").get_start()
		add_child(enemyInstance)


func _on_TileMap_loaded():
	can_spaw = true
