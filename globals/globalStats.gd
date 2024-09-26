extends Node

var player_stats : Dictionary = {}
var score: int = 0
var high_score: int = 0

func update_stats(new_stats : Dictionary):
	for stat in new_stats:
		if stat in player_stats:
			player_stats[stat] += new_stats[stat]
		else:
			player_stats[stat] = new_stats[stat]



func add_score(value: int):
	score += value
	if score > high_score:
		high_score = score

func reset_score():
	score = 0
