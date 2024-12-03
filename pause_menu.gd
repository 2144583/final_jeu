extends Control

var is_clicking = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/VBoxContainer/Resume_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = false
		queue_free()


func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	queue_free()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	var settings_menu_scene = preload("res://settings_menu.tscn")
	var settings_menu = settings_menu_scene.instantiate()
	settings_menu.parent_menu = $CanvasLayer/VBoxContainer/Resume_button

	# Ajouter le menu comme enfant de la scène principale
	add_child(settings_menu)
