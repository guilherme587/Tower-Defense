extends Camera2D

var interpolate_val = 1


func _physics_process(delta):
	var mid_x = get_global_mouse_position().x
	var mid_y = get_global_mouse_position().y
	
	if mid_x > (get_viewport().size[0] * .7) or mid_x < (get_viewport().size[0] * .3)  or mid_y < (get_viewport().size[1] * .3)  or mid_y > (get_viewport().size[1] * .7):
		global_position = global_position.linear_interpolate(Vector2(mid_x,mid_y), interpolate_val * delta) 
