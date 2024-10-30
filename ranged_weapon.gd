extends Node2D
class_name ranged_weapon

var BASE_DMG : float
var BASE_ATTACK_SPEED : float

var _damage : float
var _attack_speed : float
var _tier : int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_adjust_stats()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _adjust_stats() -> void:
	_attack_speed = BASE_ATTACK_SPEED + _tier
	_damage = BASE_DMG + ((_tier - 1) * 2)
	
func shoot() -> void:
	pass
