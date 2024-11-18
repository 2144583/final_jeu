extends RigidBody2D

var animator
var player_position : Vector2
@onready var player = get_parent().get_node("Player")

var is_dead = false

var BASE_HEALTH : int = 5
var health

func _ready() -> void:
	animator = $AnimationPlayer
	health = BASE_HEALTH
	add_to_group("enemies")
	

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	player_position = player.global_position
	angular_velocity = 0
	position += (player_position - global_position).normalized() * 3
	if animator.current_animation != "walk":
		animator.play("walk")

func take_damage(bullet: Bullet) -> void:
	health = health - bullet.damage
	print("ayoye ", health)
	if health <= 0:
		die()
	
func die() -> void:
	is_dead = true
	queue_free()
