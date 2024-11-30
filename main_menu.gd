extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$AnimationPlayer.play("menu")
	pass


func _on_button_pressed() -> void:
	$AudioStreamPlayer.stop()
	get_tree().change_scene_to_file("res://world.tscn")


func _on_settings_button_pressed() -> void:
	var settings_menu_scene = preload("res://settings_menu.tscn")
	var settings_menu = settings_menu_scene.instantiate()

	# Ajouter le menu comme enfant de la scène principale
	add_child(settings_menu)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
