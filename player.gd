extends CharacterBody2D

class_name Player

@onready var _animation_player = $AnimationPlayer

var gun_scene: PackedScene
var gun_instance: Node2D
@onready var weapon_slots = [$Weapon_slot1, $Weapon_slot2, $Weapon_slot3, $Weapon_slot4]


#Basic player stats here
var max_health = 30
var health = max_health
var speed: float = 300.0
var push_force = 20

#Everything XP here
var xp = 0
@export var BASE_XP_REQUIREMENT = 5;
var xp_requirement = BASE_XP_REQUIREMENT
var level = 1
var level_up_count = 0

#UI Elements here
var hp_bar : TextureProgressBar
var xp_bar : TextureProgressBar
var wave_label : Label
var level_label : Label
var time_left_label : Label
var fps : Label

func _ready():
	
	hp_bar = $CanvasLayer.get_child(0)
	hp_bar.update_value(health, max_health)
	xp_bar = $CanvasLayer.get_child(1)
	xp_bar.update_value(xp, xp_requirement)
	wave_label = $CanvasLayer.get_child(2)
	level_label = $CanvasLayer.get_child(3)
	time_left_label = $CanvasLayer.get_child(4)
	fps = $CanvasLayer/FPS
	
	wave_label.text = "Manche : 1"
	level_label.text = "niveau : 1"
	
	gun_scene = load("res://pistol.tscn")
	gun_instance = gun_scene.instantiate()

	# Positionner le fusil à l'emplacement de gun_position
	
	gun_instance.position = weapon_slots[0].position

	# Ajouter le fusil comme enfant du personnage
	weapon_slots[0].add_child(gun_instance)
	
	
	add_to_group("player")

func equip_weapon(weapon_name: String) -> void:
	gun_scene = load("res://%s.tscn" % weapon_name)
	
	var free_slot = get_free_weapon_slot()
	if not free_slot:
		return

	var gun_instance = gun_scene.instantiate()

	gun_instance.position = Vector2.ZERO
	free_slot.add_child(gun_instance)

func get_free_weapon_slot() -> Node2D:
	for slot in weapon_slots:
		if slot.get_child_count() == 0:  # Vérifie si le slot est vide
			return slot
	return null

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
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")


	input_vector = input_vector.normalized()

	
	velocity = input_vector * speed
	move_and_slide()
	
	if Input.is_action_just_pressed("debug"):
		fps.visible = !$CanvasLayer/FPS.visible

	if Input.is_action_just_pressed("die"):
		die()
	
	if Input.is_action_just_pressed("pause"):
		var pause_scene = preload("res://pause_menu.tscn")
		var pause_menu = pause_scene.instantiate()
		get_parent().add_child(pause_menu)
		get_parent().get_tree().paused = true
		
	
	if input_vector != Vector2.ZERO:
		if not _animation_player.is_playing(): 
			_animation_player.play("walk") 
	else:  
			_animation_player.play("RESET")

	for i in range(get_slide_collision_count()):
		var body = get_slide_collision(i).get_collider()
		if body.is_in_group("enemies"): 
			var direction = (body.position - position).normalized()
			body.apply_impulse(direction * push_force) 

func take_damage(damage : int) -> void:
	health = health - damage
	show_damage(damage)
	hp_bar.update_value(health, max_health)
	$Sprite2D.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.1).timeout
	$Sprite2D.modulate = Color(1, 1, 1)
	if health <= 0:
		die()

func show_damage(damage):
	var label = Label.new()
	label.label_settings = LabelSettings.new()
	
	label.label_settings.font_size = 32
	label.label_settings.font = preload("res://assets/Fonts/Super Shiny.ttf")
	
	label.modulate = Color(1, 0.1, 0)
	label.text = str(damage)
	add_child(label)
	label.position = Vector2(0, -50)
	
	var tween = create_tween()
	tween.tween_property(label, "position", label.position + Vector2(randf_range(-50, 50), -30), 0.5) 
	tween.tween_property(label, "modulate:a", 0, 0.5)
	await tween.finished
	label.queue_free()
	
func gainxp(enemy_xp):
	xp += enemy_xp
	if xp >= xp_requirement:
		level_up_count += 1
		level_up()
	
	xp_bar.update_value(xp, xp_requirement)

func level_up():
	level += 1
	level_label.text = "niveau : %d" % level
	xp = xp - xp_requirement
	xp_requirement += 5 + (get_parent().current_wave * 0.1)
	print("LEVEL UP : ", level)

func die():
	var losing_scene = preload("res://losing_menu.tscn")
	var losing_menu = losing_scene.instantiate()
	get_parent().add_child(losing_menu)
	get_parent().get_tree().paused = true
