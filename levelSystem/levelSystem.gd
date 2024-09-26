# power_system.gd
extends Node

class_name PowerSystem

class Power:
	var id: String
	var name: String
	var description: String
	var level: int = 1
	var max_level: int

	func _init(p_id: String, p_name: String, p_description: String, p_max_level: int):
		id = p_id
		name = p_name
		description = p_description
		max_level = p_max_level

	func level_up():
		if level < max_level:
			level += 1
			return true
		return false

	func get_description() -> String:
		return description + " (Nivel " + str(level) + ")"

var available_powers: Array[Power] = []
var active_powers: Dictionary = {}

func _ready():
	_initialize_powers()

func _initialize_powers():
	available_powers = [
		Power.new("speed_boost", "Aumento de Velocidad", "Aumenta la velocidad de movimiento", 5),
		Power.new("damage_up", "Aumento de Daño", "Incrementa el daño causado", 5),
		Power.new("health_regen", "Regeneración de Salud", "Regenera salud con el tiempo", 3),
		Power.new("area_attack", "Ataque de Área", "Daña a enemigos cercanos periódicamente", 3),
		Power.new("projectile_boost", "Mejora de Proyectiles", "Aumenta la velocidad y el tamaño de los proyectiles", 4)
	]

func get_random_powers(count: int) -> Array[Power]:
	var powers_copy = available_powers.duplicate()
	powers_copy.shuffle()
	return powers_copy.slice(0, min(count, powers_copy.size()))

func activate_power(power: Power):
	if power.id in active_powers:
		if active_powers[power.id].level_up():
			print("Power leveled up: " + power.name)
		else:
			print("Power already at max level: " + power.name)
	else:
		active_powers[power.id] = power
		print("New power activated: " + power.name)

func apply_active_powers(player):
	for power in active_powers.values():
		match power.id:
			"speed_boost":
				player.speed += 10 * power.level
			"damage_up":
				player.damage += 5 * power.level
			"health_regen":
				player.health_regen_rate = 1 * power.level
			"area_attack":
				player.area_attack_damage = 10 * power.level
				player.area_attack_radius = 50 + (10 * power.level)
			"projectile_boost":
				player.projectile_speed += 50 * power.level
				player.projectile_size += 0.1 * power.level
