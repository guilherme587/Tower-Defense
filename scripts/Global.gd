extends Node


func dist_to(par1, par2):
	if is_instance_valid(par1) and is_instance_valid(par2):
		return sqrt( pow( (par2.global_position[0] - par1.global_position[0]), 2) + pow( (par2.global_position[1] - par1.global_position[1]), 2) )
	return 0
