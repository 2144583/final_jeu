extends Node2D
class_name ranged_weapon

var _damage : float
var _attack_speed : float
var _tier : int = 1
var _range: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_adjust_stats()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _adjust_stats() -> void:
	pass
	
func shoot() -> void:
	pass
