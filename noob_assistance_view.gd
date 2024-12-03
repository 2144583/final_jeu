extends Control

var parent_menu : Control
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/BackButton.grab_focus()

func _on_back_button_pressed() -> void:
	if parent_menu:
		parent_menu.grab_focus()
	queue_free()
