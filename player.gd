extends CharacterBody2D

# Vitesse de déplacement du personnage
var speed: float = 300.0
@onready var _animation_player = $AnimationPlayer


func _process(delta: float) -> void:
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")


	input_vector = input_vector.normalized()

	
	velocity = input_vector * speed
	move_and_slide()
	
	if input_vector != Vector2.ZERO:
		if not _animation_player.is_playing(): 
			_animation_player.play("walk") 
	else:  
			_animation_player.play("RESET")
