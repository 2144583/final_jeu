extends Node2D
class_name Bullet

var BASE_SPEED = 500
var direction = Vector2()
var damage

signal bullet_out_of_screen
var camera: Camera2D
var screen_rect: Rect2

var life_timer: Timer

func _ready():
	# Créer un Timer pour gérer la durée de vie de la balle
	life_timer = Timer.new()
	add_child(life_timer)  # Ajoute le timer à la scène de la balle
	life_timer.wait_time = 5  # Durée de vie de 5 secondes
	life_timer.connect("timeout", Callable(self, "_on_life_timer_timeout"))
	life_timer.start()  # Démarre le timer

func _physics_process(delta):
	position += direction * BASE_SPEED * delta


# Fonction appelée lorsque le timer de durée de vie expire
func _on_life_timer_timeout():
	queue_free()  # La balle est détruite après 5 secondes

func get_camera_screen_rect() -> Rect2:
	var viewport_size = get_viewport().get_visible_rect().size
	var top_left = camera.global_position - (viewport_size / 2)
	return Rect2(top_left, viewport_size)


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
