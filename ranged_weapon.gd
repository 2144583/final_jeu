extends Node2D
class_name ranged_weapon

var _mindamage : int
var _maxdamage : int
var _attack_speed : float
var _tier : int = 1
var _range: int

var target : Node2D
var target_enemy: Node2D
var closest_distance = INF
var closest_enemy = null

var player: Player
var camera: Camera2D

var bullet_scene : PackedScene = preload("res://bullet.tscn")
var bullet : Bullet

var last_shot_time : float = -INF
var cooldown : float

@onready var _animation_player = $AnimationPlayer
@onready var shoot_sound : AudioStreamPlayer = $shoot
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	_adjust_stats()
	
	player = get_parent().get_parent()
	camera = player.get_node("Camera2D")
	cooldown = 1 / _attack_speed
	$Timer.wait_time = cooldown

func _get_closest_enemy(enemies):
	
	closest_enemy = null
	var min_distance = INF
	for enemy in enemies:
		if is_instance_valid(enemy):
			var distance = global_position.distance_to(enemy.global_position)
			if distance < min_distance:
				min_distance = distance
				closest_enemy = enemy
	return closest_enemy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() > 0:
		target = _get_closest_enemy(enemies)
	if target != null and target :
		if is_instance_valid(target):
			look_at(target.global_position)
			rotation_degrees = wrapf(rotation_degrees, 0, 360)
			get_child(0).flip_v = abs(rotation_degrees) > 90 and abs(rotation_degrees) < 270 


func shoot():
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_shot_time >= cooldown:
		if target:
			if is_instance_valid(target):
				var distance = global_position.distance_to(target.global_position)
				
				if distance <= _range:
					_animation_player.play("shoot")
					shoot_sound.play()
					bullet = bullet_scene.instantiate()
					bullet.damage = randi_range(_mindamage, _maxdamage)
					bullet.camera = camera
					var world = get_node("../../../")
					world.add_child(bullet)
					bullet.global_position = $Muzzle.global_position
					bullet.global_rotation = $Muzzle.global_rotation
					var shoot_direction = $Muzzle.global_transform.x.normalized()
					bullet.direction = shoot_direction 
					bullet.owner = null


func _adjust_stats() -> void:
	pass



func _on_timer_timeout() -> void:
	shoot()
