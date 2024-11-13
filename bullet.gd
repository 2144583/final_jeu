extends Node2D
class_name Bullet

var BASE_SPEED = 100
var direction = Vector2()

signal bullet_out_of_screen

func _physics_process(delta):
	position += transform.x * BASE_SPEED * delta
	
	if is_out_of_screen():
		print("bullet out of screen")
		emit_signal("bullet_out_of_screen", self)
	

		
func is_out_of_screen() -> bool:
	var screen_rect = get_viewport_rect()
	return position.x < 0 or position.x > screen_rect.size.x or position.y < 0 or position.y > screen_rect.size.y
