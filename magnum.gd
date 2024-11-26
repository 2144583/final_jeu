extends ranged_weapon

func _adjust_stats() -> void:
	_mindamage = 100
	_maxdamage = (_mindamage * 2) + 1
	_range = 200
	_attack_speed = 0.5
