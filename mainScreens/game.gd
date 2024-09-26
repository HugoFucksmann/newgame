extends Node

var time_left : float = 180  # 3 minutes
var enemy_spawn_timer : Timer

func _ready():
	enemy_spawn_timer = Timer.new()
	add_child(enemy_spawn_timer)
	enemy_spawn_timer.connect("timeout", Callable(self, "_on_enemy_spawn_timer_timeout"))
	enemy_spawn_timer.start(1.0)  # Spawn every second

func _process(delta):
	time_left -= delta
	if time_left <= 0:
		win_game()

func _on_enemy_spawn_timer_timeout():
	spawn_enemy()

func spawn_enemy():
	var enemy_data = load_enemy_data()
	var enemy = preload("res://scenes/Enemy.tscn").instantiate()
	enemy.init(enemy_data)
	add_child(enemy)

func win_game():
	print("You survived! You win!")

func lose_game():
	print("You died! Game Over!")
