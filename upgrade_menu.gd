extends CanvasLayer

var upgrade_manager_scene : PackedScene
var upgrade_manager : Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	upgrade_manager_scene = preload("res://upgrade_manager.tscn")
	upgrade_manager = upgrade_manager_scene.instantiate()
	add_child(upgrade_manager)
	shuffle_upgrades()
	
func shuffle_upgrades():
	var shuffled_upgrades = upgrade_manager.all_upgrades
	shuffled_upgrades.shuffle()
	var random_upgrades = shuffled_upgrades.slice(0, 3)
	
	var containers = [
		$HBoxContainer/MarginContainer,
		$HBoxContainer/MarginContainer2,
		$HBoxContainer/MarginContainer3
	]
	var index = 0
	for upgrade in random_upgrades:
		var button = preload("res://upgrade_button.tscn").instantiate()
		button.setup(upgrade)
		var container = containers[index]
		container.add_child(button)
		index += 1


func _process(delta: float) -> void:
	pass
