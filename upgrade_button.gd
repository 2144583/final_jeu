extends Button

var upgrade: Upgrade
var player: CharacterBody2D


signal upgrade_selected(upgrade: Upgrade)

func setup(upgrade: Upgrade, player: CharacterBody2D):
	self.player = player
	self.upgrade = upgrade
	self.text = upgrade.name
	$Label.text = upgrade.description
	var icon_node = $TextureRect/Icon
	if icon_node and icon_node is TextureRect:
		icon_node.texture = upgrade.icon

		icon_node.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED  # Conserve les proportions et centre
		icon_node.custom_minimum_size = Vector2(64, 64)  # Taille minimale pour toutes les icônes



func _on_pressed() -> void:
	print("Applying upgrade: ", upgrade.name)
	emit_signal("upgrade_selected", upgrade)
	upgrade.apply(player)  # Exemple d'appel
	var world_scene = preload("res://world.tscn")
	
