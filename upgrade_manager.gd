extends Node
var all_upgrades = [
	Upgrade.new(
		"Augmentation des dégâts",
		"+20% de dégâts",
		preload("res://assets/Sprites/muscles.png"),
		Callable(self, "increase_damage"),
		1
	),
	Upgrade.new(
		"Vitesse de déplacement",
		"+15% de vitesse",
		preload("res://assets/Sprites/speed.png"),
		Callable(self, "increase_speed"),
		1
	),
	Upgrade.new(
		"Bonus de vie",
		"+15HP",
		preload("res://assets/Sprites/poumon.png"),
		Callable(self, "HP_up"),
		1
	),
	Upgrade.new(
		"Vorace",
		"+15% vitesse d'attaque",
		preload("res://assets/Sprites/fangs.png"),
		Callable(self, "attack_speed_up"),
		1
	),
	Upgrade.new(
		"Petit pot de nutella",
		"+75% de dégâts",
		preload("res://assets/Sprites/nutella.png"),
		Callable(self, "nutella_damage_boost"),
		2
	),
	Upgrade.new(
		"Gros pot de PEANUT BUTTAH",
		"degats x2.5",
		preload("res://assets/Sprites/peanut_butter.png"),
		Callable(self, "peanut_butter_damage_boost"),
		3
	),
	Upgrade.new(
		"AK-47",
		"RATATATATATATA",
		preload("res://assets/Sprites/AK-47.png"),
		Callable(self, "player_equip_ak"),
		4
	),
	Upgrade.new(
		"pistol",
		"pew pew",
		preload("res://assets/Sprites/pistol.png"),
		Callable(self, "player_equip_pistol"),
		3
	),
	Upgrade.new(
		"magnum",
		"BANG BANG",
		preload("res://assets/Sprites/magnum.png"),
		Callable(self, "player_equip_magnum"),
		3
	),
	Upgrade.new(
		"jelly time",
		"+20% portee",
		preload("res://assets/Sprites/jelly-strawberry.png"),
		Callable(self, "increase_range"),
		4
	),
]

func increase_damage(player):
	var weapon_slots = [
		player.get_node("Weapon_slot1"),
		player.get_node("Weapon_slot2"),
		player.get_node("Weapon_slot3"),
		player.get_node("Weapon_slot4")
	]
	for weapon_slot in weapon_slots:
		if weapon_slot.get_child_count() == 1:
			var weapon = weapon_slot.get_child(0)
			print("L'arme équipée est : ", weapon)
			weapon._mindamage *= 1.2
			weapon._maxdamage = (weapon._mindamage * 2) + 1

func increase_speed(player):
	player.speed *= 1.15

func HP_up(player):
	player.max_health += 15
	player.hp_bar.update_value(player.max_health, player.max_health)

func attack_speed_boost(player):
	var weapon_slots = [
		player.get_node("Weapon_slot1"),
		player.get_node("Weapon_slot2"),
		player.get_node("Weapon_slot3"),
		player.get_node("Weapon_slot4")
	]
	for weapon_slot in weapon_slots:
		if weapon_slot.get_child_count() == 1:
			var weapon = weapon_slot.get_child(0)
			print("L'arme équipée est : ", weapon)
			weapon._attack_speed *= 1.15
	
func nutella_damage_boost(player):
	var weapon_slots = [
		player.get_node("Weapon_slot1"),
		player.get_node("Weapon_slot2"),
		player.get_node("Weapon_slot3"),
		player.get_node("Weapon_slot4")
	]
	for weapon_slot in weapon_slots:
		if weapon_slot.get_child_count() == 1:
			var weapon = weapon_slot.get_child(0)
			print("L'arme équipée est : ", weapon)
			weapon._mindamage *= 1.75
			weapon._maxdamage = (weapon._mindamage * 2) + 1

	
func peanut_butter_damage_boost(player):
	var weapon_slots = [
		player.get_node("Weapon_slot1"),
		player.get_node("Weapon_slot2"),
		player.get_node("Weapon_slot3"),
		player.get_node("Weapon_slot4")
	]
	for weapon_slot in weapon_slots:
		if weapon_slot.get_child_count() == 1:
			var weapon = weapon_slot.get_child(0)
			print("L'arme équipée est : ", weapon)
			weapon._mindamage *= 2.5
			weapon._maxdamage = (weapon._mindamage * 2) + 1

	
func player_equip_ak(player):
	player.equip_weapon("ak_47")

	
func player_equip_pistol(player):
	player.equip_weapon("pistol")
	

	
func player_equip_magnum(player):
	player.equip_weapon("magnum")


func increase_range(player):
	var weapon_slots = [
		player.get_node("Weapon_slot1"),
		player.get_node("Weapon_slot2"),
		player.get_node("Weapon_slot3"),
		player.get_node("Weapon_slot4")
	]
	for weapon_slot in weapon_slots:
		if weapon_slot.get_child_count() == 1:
			var weapon = weapon_slot.get_child(0)
			print("L'arme équipée est : ", weapon)
			weapon._range *= 1.20
	
