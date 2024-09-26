# game_scene.gd
extends Node2D

var power_system: PowerSystem
var enemy_system: EnemySystem
var player_level: int = 1
var experience: float = 0
var experience_to_level_up: float = 100

@onready var player = $Player
@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var power_selection_menu = $CanvasLayer/PowerSelectionMenu
@onready var enemy_container = $EnemyContainer
@onready var spawn_timer = $SpawnTimer

var current_wave: int = 1
var enemies_in_wave: int = 5
var enemies_spawned: int = 0

signal enemy_defeated(enemy)

func _ready():
	power_system = PowerSystem.new()
	enemy_system = EnemySystem.new()
	add_child(power_system)
	add_child(enemy_system)
	pause_menu.hide()
	power_selection_menu.hide()
	
	spawn_timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	self.connect("enemy_defeated", Callable(self, "_on_enemy_defeated"))

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func toggle_pause():
	get_tree().paused = !get_tree().paused
	pause_menu.visible = get_tree().paused

func add_experience(amount: float):
	experience += amount
	if experience >= experience_to_level_up:
		level_up()

func level_up():
	player_level += 1
	experience -= experience_to_level_up
	experience_to_level_up *= 1.2  # Increase exp required for next level

	get_tree().paused = true
	show_power_selection()

func show_power_selection():
	var powers_to_choose = power_system.get_random_powers(3)
	power_selection_menu.display_powers(powers_to_choose)
	power_selection_menu.show()

func _on_power_selected(power):
	power_system.activate_power(power)
	power_system.apply_active_powers(player)
	power_selection_menu.hide()
	get_tree().paused = false

func _on_spawn_timer_timeout():
	if enemies_spawned < enemies_in_wave:
		spawn_enemy()
		enemies_spawned += 1
	else:
		current_wave += 1
		enemies_in_wave += 2
		enemies_spawned = 0

func spawn_enemy():
	var enemy_types = ["slime", "goblin", "orc"]
	var spawn_weights = [3, 2, 1]  # Adjust these weights as needed
	
	var total_weight = 0
	for weight in spawn_weights:
		total_weight += weight
	
	var random_value = randf() * total_weight
	var enemy_index = 0
	var current_weight = 0
	
	for i in range(spawn_weights.size()):
		current_weight += spawn_weights[i]
		if random_value <= current_weight:
			enemy_index = i
			break
	
	var enemy_type = enemy_types[enemy_index]
	var enemy_data = enemy_system.get_enemy_data(enemy_type)
	
	if player_level >= enemy_data["spawn_level"]:
		var enemy = enemy_system.create_enemy(enemy_type)
		if enemy:
			enemy_container.add_child(enemy)
			enemy.position = get_random_spawn_position()
			enemy.connect("tree_exiting", Callable(self, "_on_enemy_defeated").bind(enemy))

func get_random_spawn_position() -> Vector2:
	var viewport_rect = get_viewport_rect()
	var spawn_margin = 50
	var x = randf_range(-spawn_margin, viewport_rect.size.x + spawn_margin)
	var y = randf_range(-spawn_margin, viewport_rect.size.y + spawn_margin)
	
	if x > 0 and x < viewport_rect.size.x:
		y = viewport_rect.size.y + spawn_margin if y > viewport_rect.size.y / 2 else -spawn_margin
	
	return Vector2(x, y)

func _on_enemy_defeated(enemy):
	GlobalState.add_score(enemy.score_value)
	add_experience(enemy.experience_value)
	print("Enemy defeated! Score: ", GlobalState.score, " Experience: ", experience)
