extends ranged_weapon

func _adjust_stats() -> void:
	_mindamage = 50
	_maxdamage = (_mindamage * 2) + 1
	_range = 500
	_attack_speed = 10
