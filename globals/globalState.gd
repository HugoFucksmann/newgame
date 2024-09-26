extends Node

var unlocked_levels : Array = []
var available_powers : Array = []

func unlock_level(level : int):
	if level not in unlocked_levels:
		unlocked_levels.append(level)
