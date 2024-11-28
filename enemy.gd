extends RigidBody2D

var animator
var player_position : Vector2
@onready var player = get_parent().get_node("Player")

var is_dead = false
signal enemy_died
var health
var damage
var speed
var xp = 1

signal damage_received(amount, position)

func _ready() -> void:
	animator = $AnimationPlayer
	add_to_group("enemies")

func _physics_process(_delta: float) -> void:
	if is_dead:
		return
	
	player_position = player.global_position
	angular_velocity = 0
	position += (player_position - global_position).normalized() * speed
	if animator.current_animation != "walk":
		animator.play("walk")

func take_damage(bullet: Bullet) -> void:
	health = health - bullet.damage
	emit_signal("damage_received", bullet.damage, global_position)
	if health <= 0:
		die()
	$Sprite2D.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.1).timeout
	$Sprite2D.modulate = Color(1, 1, 1)
	

func show_damage(bullet_damage):
	var damage = Label.new()
	damage.text = str(bullet_damage)
	damage.label_settings = LabelSettings.new()
	
	damage.label_settings.font_size = 32
	damage.label_settings.font = preload("res://assets/menu/Super Shiny.ttf")
	
	
	add_child(damage)
	damage.global_position = global_position + damage.position
	
	var tween = create_tween()
	tween.tween_property(damage, "position", damage.position + Vector2(randf_range(-50, 50), -30), 0.5) 
	tween.tween_property(damage, "modulate:a", 0, 0.5)
	

	
	await tween.finished
	damage.queue_free()  

func die() -> void:
	is_dead = true
	emit_signal("enemy_died", self)
	player.gainxp(xp)
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.take_damage(damage)
