extends CharacterBody2D

class_name Player
# Vitesse de déplacement du personnage
var speed: float = 300.0
@onready var _animation_player = $AnimationPlayer
var push_force = 20
var gun_scene: PackedScene
var gun_scene2: PackedScene
var gun_scene3: PackedScene
var gun_scene4: PackedScene
# Variable pour stocker l'instance du fusil
var gun_instance: Node2D
var gun_instance2: Node2D
var gun_instance3: Node2D
var gun_instance4: Node2D

var BASE_HEALTH : int = 5
var health

func _ready():
	health = BASE_HEALTH
	add_to_group("player")
	
	gun_scene = preload("res://pistol.tscn")
	gun_instance = gun_scene.instantiate()

	# Positionner le fusil à l'emplacement de gun_position
	var weapon_slot = $Weapon_slot1
	gun_instance.position = weapon_slot.position

	# Ajouter le fusil comme enfant du personnage
	weapon_slot.add_child(gun_instance)
	
	#=============================
	
	gun_scene2 = preload("res://pistol.tscn")
	gun_instance2 = gun_scene.instantiate()
	
	var weapon_slot2 = $Weapon_slot2
	gun_instance2.position = weapon_slot2.position

	# Ajouter le fusil comme enfant du personnage
	weapon_slot2.add_child(gun_instance2)
	
	#===============================
	
	gun_scene3 = preload("res://pistol.tscn")
	gun_instance3 = gun_scene3.instantiate()

	# Positionner le fusil à l'emplacement de gun_position
	var weapon_slot3 = $Weapon_slot3
	gun_instance3.position = weapon_slot3.position

	# Ajouter le fusil comme enfant du personnage
	weapon_slot3.add_child(gun_instance3)
	
	#========================================
	
	gun_scene4 = preload("res://pistol.tscn")
	gun_instance4 = gun_scene4.instantiate()

	# Positionner le fusil à l'emplacement de gun_position
	var weapon_slot4 = $Weapon_slot4
	gun_instance4.position = weapon_slot4.position

	# Ajouter le fusil comme enfant du personnage
	weapon_slot4.add_child(gun_instance4)
	



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
	
func die():
	print("ono")
