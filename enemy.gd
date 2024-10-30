extends Node2D

const SPEED = 300.0

var animator
var player_position : Vector2
@onready var player = get_parent().get_node("Player")

func _ready() -> void:
	animator = $AnimationPlayer
	

func _physics_process(delta: float) -> void:
	if player:
		print("player existant")
	player_position = player.global_position
	position += (player_position - global_position).normalized() * 3
	print(player_position)
	if animator.current_animation != "walk":
		animator.play("walk")
