extends CanvasLayer

var upgrade_manager_scene : PackedScene
var upgrade_manager : Node
@onready var player : CharacterBody2D = get_parent().get_node("Player")
var upgrade_count : int
@onready var upgrade_counter_label = $upgradecount/counter
@onready var level_up_counter_label = $levelupCounter/levelcounter
@onready var containers = [
		$HBoxContainer/MarginContainer,
		$HBoxContainer/MarginContainer2,
		$HBoxContainer/MarginContainer3
	]
var is_clicking = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	upgrade_manager_scene = preload("res://upgrade_manager.tscn")
	upgrade_manager = upgrade_manager_scene.instantiate()
	add_child(upgrade_manager)
	upgrade_count = player.level_up_count
	upgrade_counter_label.text = ("%s restante(s)" % upgrade_count) 
	level_up_counter_label.text = ("%s fois" % player.level_up_count) 
	$AudioStreamPlayer.play()
	
	
	check_level_ups()

func is_on_arcade() -> bool:
	return OS.get_executable_path().to_lower().contains("retropie")

func manage_end_game() -> void:
	if is_on_arcade() :
		if Input.is_action_pressed("Hotkey") and Input.is_action_pressed("Quit"):
			get_tree().quit()
	else :
		if Input.is_action_just_pressed("Quit"):
			get_tree().quit()

func _process(_delta: float) -> void:
	manage_end_game()

func check_level_ups():
	if player.level_up_count > 0:
		shuffle_upgrades()	
	else:
		get_tree().paused = false
		queue_free()

func shuffle_upgrades():
	
	var index = 0
	var weighted_upgrades = []
	for upgrade in upgrade_manager.all_upgrades:
		var weight = max(1, 7 - upgrade.rarity)
		for i in range(weight):
			weighted_upgrades.append(upgrade)
	
	
	weighted_upgrades.shuffle()
	var random_upgrades = weighted_upgrades.slice(0, 3)  
	
	upgrade_count -= 1
	
	for container in containers:
		if container.get_child_count() == 1:
			var container_child = container.get_child(0)
			container_child.queue_free()
	
	for upgrade in random_upgrades:
		var button = preload("res://upgrade_button.tscn").instantiate()
		button.setup(upgrade, player)
		button.connect("upgrade_selected", Callable(self, "_on_upgrade_selected"))
		var container = containers[index]
		container.add_child(button)
		index += 1
	
	set_initial_focus()

func set_initial_focus():
	for container in containers:
		if container.get_child_count() > 0:
			container.get_child(0).grab_focus()
			break

func _on_upgrade_selected(upgrade: Upgrade) -> void:
	if upgrade_count == 0:
		get_tree().paused = false
		queue_free()
	else:
		upgrade_counter_label.text = ("%s restante(s)" % upgrade_count) 
		shuffle_upgrades()
		await get_tree().create_timer(0.1).timeout
		$HBoxContainer/MarginContainer3.get_child(0).grab_focus()
