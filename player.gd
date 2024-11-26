extends CharacterBody2D

class_name Player
# Vitesse de déplacement du personnage

@onready var _animation_player = $AnimationPlayer

var gun_scene: PackedScene
# Variable pour stocker l'instance du fusil
var gun_instance: Node2D

#Basic player stats here
var max_health = 5
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

func _ready():
	
	hp_bar = $CanvasLayer.get_child(0)
	hp_bar.update_value(health, max_health)
	xp_bar = $CanvasLayer.get_child(1)
	xp_bar.update_value(xp, xp_requirement)
	wave_label = $CanvasLayer.get_child(2)
	level_label = $CanvasLayer.get_child(3)
	
	wave_label.text = "Manche : 1"
	level_label.text = "niveau : 1"
	
	
	add_to_group("player")
	
	gun_scene = load("res://pistol.tscn")
	gun_instance = gun_scene.instantiate()

	# Positionner le fusil à l'emplacement de gun_position
	var weapon_slot = $Weapon_slot1
	gun_instance.position = weapon_slot.position

	# Ajouter le fusil comme enfant du personnage
	weapon_slot.add_child(gun_instance)



func _process(_delta: float) -> void:
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")


	input_vector = input_vector.normalized()

	
	velocity = input_vector * speed
	move_and_slide()
	
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
	label.label_settings.font = preload("res://assets/menu/Super Shiny.ttf")
	
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
	xp_requirement += get_parent().current_wave
	print("LEVEL UP : ", level)

func die():
	print("ono")
