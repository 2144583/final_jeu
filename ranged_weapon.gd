extends Node2D
class_name ranged_weapon

var _damage : float
var _attack_speed : float
var _tier : int = 1
var _range: int
var target = Node2D
var target_enemy: Node2D
var closest_distance = INF
var closest_enemy = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_adjust_stats()
	var enemies = get_tree().get_nodes_in_group("Enemy")
	if enemies.size() > 0:
		target = _get_closest_enemy(enemies)

func _get_closest_enemy(enemies):
	var closest_enemy = null
	var min_distance = INF
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < min_distance:
			min_distance = distance
			closest_enemy = enemy
	return closest_enemy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() > 0:
		target = _get_closest_enemy(enemies)
	if target:
		look_at(target.global_position)
		rotation_degrees = wrapf(rotation_degrees, 0, 360)
		print(rotation_degrees)
		get_child(0).flip_v = abs(rotation_degrees) > 90
	
func _adjust_stats() -> void:
	pass
	
func shoot() -> void:
	pass
