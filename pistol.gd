extends ranged_weapon

func _adjust_stats() -> void:
	_mindamage = 2
	_maxdamage = (_mindamage * 2) + 1
	_range = 300
	_attack_speed = 1
