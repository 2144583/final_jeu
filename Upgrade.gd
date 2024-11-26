extends Node
class_name Upgrade


var Name: String
var description: String
var icon: Texture
var rarity : int
var effect: Callable  # Fonction à appeler quand l'upgrade est choisie

func _init(name: String, description: String, icon: Texture, effect: Callable, rarity: int):
	self.name = name
	self.description = description
	self.icon = icon
	self.effect = effect
	self.rarity = rarity

func apply(player):
	effect.call_deferred(player)
