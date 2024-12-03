extends Control

var parent_menu: Control = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/Button.grab_focus()

func _on_button_pressed() -> void:
	if parent_menu:
		parent_menu.grab_focus()
	queue_free()


func _on_how_to_play_pressed() -> void:
	var assistance_menu_scene = preload("res://noob_assistance_view.tscn")
	var assistance_menu = assistance_menu_scene.instantiate()
	assistance_menu.parent_menu = $CanvasLayer/Button

	# Ajouter le menu comme enfant de la scène principale
	add_child(assistance_menu)
