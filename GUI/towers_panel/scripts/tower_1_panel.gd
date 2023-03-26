extends ColorRect

export var money 			:int 			= 250
export var tower 			:PackedScene

onready var cellPath 		:Array 			= get_parent().get_parent().get_parent().get_parent().get_node("Navigation2D/TileMap").get_random_path()

var towerInstance 			:Object 		= null
var cellWithTower 			:Array 			= []


func _ready():
	var towerInstance = tower.instance()
	money = towerInstance.money


func _physics_process(delta):
	$"../../../Label".text = str(Game.money) + " R$"
	
	self.modulate.a8 = 100 if Game.money <= money else 255
	
	if towerInstance:
		towerInstance.global_position = get_grid()
		get_parent().get_parent().get_parent().add_child(towerInstance)
		towerInstance.can_shot = false


func _on_tower_1_panel_gui_input(event):
	if event is InputEventMouseButton and event.button_mask == 1:
		cellPath  = get_parent().get_parent().get_parent().get_parent().get_node("Navigation2D/TileMap").get_random_path()
		towerInstance = tower.instance()
		if Game.money < towerInstance.money:
			cant_shop()
	if event is InputEventMouseButton and event.button_mask == 0:
		if cellWithTower.has(get_grid()) or cellPath.has( ( get_grid() + Vector2(16, 16) ) ):
			cant_put()
			return
		var pos = get_grid()
		
		if towerInstance:
			towerInstance.global_position 	= pos
			towerInstance.can_shot 			= true
			towerInstance 					= null
			cellWithTower.append(pos)


func cant_shop():
	towerInstance.baseInstance.queue_free()
	towerInstance.queue_free()
	towerInstance 	= null


func cant_put():
	Game.money += towerInstance.money
	towerInstance.baseInstance.queue_free()
	towerInstance.queue_free()
	towerInstance 	= null


func get_grid():
	var pos = get_global_mouse_position()
	pos[0] = int(pos[0]/32)
	pos[1] = int(pos[1]/32)
	pos[0] = int(pos[0]*32)
	pos[1] = int(pos[1]*32)
	
	return ( pos - Vector2(16, 16) )


func _on_Button_pressed():
	if $"../../../Button".rect_position.y == 560:
		$"../../../Button".text = "DOWN"
		$"../../../Button".rect_position.y = 440
		$"../..".rect_position.y = 600
	else:
		$"../../../Button".text = "UP"
		$"../../../Button".rect_position.y = 560
		$"../..".rect_position.y = 725
