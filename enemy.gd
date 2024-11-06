extends RigidBody2D

const SPEED = 300.0
var animator
var player_position : Vector2
@onready var player = get_parent().get_node("Player")


func _ready() -> void:
	animator = $AnimationPlayer
	angular_velocity = 0
	add_to_group("enemies")
	

func _physics_process(delta: float) -> void:
	player_position = player.global_position
	position += (player_position - global_position).normalized() * 3
	if animator.current_animation != "walk":
		animator.play("walk")
