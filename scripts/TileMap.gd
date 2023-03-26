extends TileMap

signal loaded

export var width 					:int 			= 1024
export var height 					:int 			= 600
export var decoration_amount		:int			= 20
export var random 					:bool 			= false
export var random_curve 			:bool 			= false

onready var area					:Area2D				= $Area2D

var noise
onready var navigation_path 		:Navigation2D 		= $Navigation2D
onready var tile 					:TileMap 			= null
onready var end						:Vector2 			= Vector2.ZERO
onready var start					:Vector2			= Vector2.ZERO
var path							:Array				= []
var not_path 						:Array				= []
var lines 							:Array 				= []
var decoration						:Array				= []
var num_tile_decoratio				:int 				= 3
var num_tile_groud					:int				= 4

func _ready():
	width 		/= self.cell_size[0]
	height		/= self.cell_size[0]
	
	tile = self
	if random_curve:
		randomize()
		draw_random_map()
	
	elif random:
		randomize()
		
		noise 				= OpenSimplexNoise.new()
		noise.seed 			= randi()
		noise.octaves 		= 2
		noise.period 		= 2
		noise.persistence	= .2
		
		draw_random_map()
	else:
		emit_signal("loaded")


func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()


func sort_startEnd_position():
	start = Vector2(-1, randi() % height )
	tile.set_cell(start[0], start[1] , 2)
	end = Vector2( width, randi() % height )
	tile.set_cell(end[0], end[1] , 3)
	
	$get_path.end				= get_end()
	$get_path.global_position 	= get_start()


func sort_line_pos(_height) -> Vector2:
	var line :Vector2 = Vector2( randi() % width, _height)
	
	if lines.has(line[0]) or lines.has(line[0] +1) or lines.has(line[0] -1):
		return sort_line_pos(_height)
	
	lines.append(line[0])
	
	return line


func draw_random_map():
	for x in width:
			for y in height:
				tile.set_cell(x, y, 0)
	
	if random_curve:
		sort_startEnd_position()
		
		var curves :int = int( randi() % 4 + 1 )
		for x in curves:
			var line 			:Vector2 		= sort_line_pos(0)
			var line_height		:int			= ( randi() % (height / 2) +  (height / 2.2))
			for y in line_height:
				tile.set_cell(line[0], (line[1] + y), 1)
			
			line 			= sort_line_pos(height)
			line_height		=  ( randi() % (height / 2) +  (height / 2.2))
			for y in line_height:
				tile.set_cell(line[0], (line[1] - y), 1)
	
	elif random:
		make_road()
		
		sort_startEnd_position()
	
	area.global_position = get_end()
	draw_path()


func make_road():
	for x in width:
			for y in height:
				var a = noise.get_noise_2d(x ,y)
				if a < .25 and a > .05:
					tile.set_cell(x, y, 1)


func random_spawn_position(width :int, height :int) -> Vector2:
	var x_pos :int = randi() % width
	var y_pos :int = randi() % height

	if decoration.has( Vector2(x_pos, y_pos) ):
		return random_spawn_position(width, height)

	decoration.append( Vector2(x_pos, y_pos) )
	
	return Vector2(x_pos, y_pos)


func draw_path():
	yield($get_path, "can_draw_path")
	
	for p in $get_path.path:
		path.append( [ int( p[0]/32 ), int( p[1]/32 ) ] )
	
	for x in width:
		for y in height + 1:
			if not path.has(x):
				not_path.append(x)
				tile.set_cell(x, y, 1)
	
	
	
	if not path.empty():
		var y :Array = [0,0]
		
		for x in path:
			decoration.append( Vector2(x[0], x[1]) )
			if x[1] > y[1]:
				tile.set_cell(y[0], x[1], 0)
				decoration.append( Vector2(y[0], x[1]) )
			if x[1] < y[1]:
				tile.set_cell(y[0], x[1], 0)
				decoration.append( Vector2(y[0], x[1]) )
			
			tile.set_cell(x[0], x[1], 0)
			y = x
	
	self.update_bitmask_region(Vector2(0, 0), Vector2(width, height))
	tile.set_cell(get_end()[0]/32, get_end()[1]/32, 3)
	
	decoration()


func decoration() -> void:
	for i in decoration_amount:
		var pos :Vector2 = random_spawn_position(width, height)
		var tile_decoration :int = randi() % num_tile_decoratio + num_tile_groud
		tile.set_cell(pos[0], pos[1], tile_decoration)
		
	emit_signal("loaded")



func get_random_path() -> Array:
	var tiles :Array = []
	
	if decoration.size() > 0:
		var i = 0
		for tile in decoration:
			tiles.append( Vector2( (tile[0] + 1) * 32, (tile[1] + 1) * 32) )
	
	return tiles


func get_start() -> Vector2:
	return start * 32


func get_end() -> Vector2:
	return end * 32


func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		body.queue_free()
