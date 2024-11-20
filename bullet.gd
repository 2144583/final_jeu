extends Node2D
class_name Bullet

var BASE_SPEED = 500
var direction = Vector2()

var damage

signal bullet_out_of_screen
var camera: Camera2D
var screen_rect: Rect2


func _physics_process(delta):
	position += direction * BASE_SPEED * delta
	screen_rect = get_camera_screen_rect()
	if is_out_of_screen(screen_rect):
		emit_signal("bullet_out_of_screen")
		queue_free()

func get_camera_screen_rect() -> Rect2:
	var viewport_size = get_viewport().get_visible_rect().size

	var top_left = camera.global_position - (viewport_size / 2)

	return Rect2(top_left, viewport_size)

func is_out_of_screen(screen_rect: Rect2) -> bool:
	if position.x < screen_rect.position.x or position.x > screen_rect.position.x + screen_rect.size.x or position.y < screen_rect.position.y or position.y > screen_rect.position.y + screen_rect.size.y:
		return true
	else: 
		return false


func _on_ennemy_hit(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(self)
		#apply_knockback(body)
		queue_free()

func apply_knockback(body: Node2D) -> void:
	var knockback_force = 100
	var knockback_direction = direction.normalized()
	var knockback_velocity = knockback_direction * knockback_force
	body.linear_velocity += knockback_velocity
