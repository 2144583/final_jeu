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
		2
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
		"+20% knockback (ca en a pas l'air mais le knockback,\n c'est vraiment fort) ",
		preload("res://assets/Sprites/jelly-strawberry.png"),
		Callable(self, "player_equip_pistol"),
		4
	),
]

func increase_damage(player):
	var weapon_slots = [player.Weapon_slot1, player.Weapon_slot2, player.Weapon_slot3, player.Weapon_slot4]
	for weapon_slot in weapon_slots:
		if weapon_slot.has_children():
			var weapon = weapon_slot.get_child()
			print("L'arme équipée est : ", weapon)
			weapon._mindamage *= 1.2
			weapon._maxdamage = (weapon._mindamage * 2) + 1

func increase_speed(player):
	player.speed *= 1.15

func HP_up(player):
	player.health += 15  
	
func nutella_damage_boost(player):
	var weapon_slots = [player.Weapon_slot1, player.Weapon_slot2, player.Weapon_slot3, player.Weapon_slot4]
	for weapon_slot in weapon_slots:
		if weapon_slot.has_children():
			var weapon = weapon_slot.get_child()
			print("L'arme équipée est : ", weapon)
			weapon._mindamage *= 1.75
			weapon._maxdamage = (weapon._mindamage * 2) + 1

	
func peanut_butter_damage_boost(player):
	var weapon_slots = [player.Weapon_slot1, player.Weapon_slot2, player.Weapon_slot3, player.Weapon_slot4]
	for weapon_slot in weapon_slots:
		if weapon_slot.has_children():
			var weapon = weapon_slot.get_child()
			print("L'arme équipée est : ", weapon)
			weapon._mindamage *= 2.5
			weapon._maxdamage = (weapon._mindamage * 2) + 1

	
func player_equip_ak(player):
	var gun_scene : PackedScene
	var gun_instance: Node2D
	for weapon_slot in player.weapon_slots:
		if weapon_slot.has_child() == false:
			gun_scene = preload("res://pistol.tscn")
			gun_instance = gun_scene.instantiate()
			gun_instance.position = weapon_slot.position
			weapon_slot.add_child(gun_instance)

	
func player_equip_pistol(player):
	player.equip_weapon("Pistol")
	

	
func player_equip_magnum(player):
	player.equip_weapom("Magnum")


func increase_knockback(player):
	pass
	#player.knockback_strength *= 1.2  # Augmente le knockback de 20%
	
