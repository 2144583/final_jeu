extends Control

var parent_menu: Control = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/Button.grab_focus()

func _on_button_pressed() -> void:
	if parent_menu:
		parent_menu.grab_focus()
	queue_free()
