extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://world.tscn")


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_leaderboard_button_pressed() -> void:
	get_tree().change_scene_to_file("res://leaderboard_view.tscn")
