extends Control



@onready var input_field = $CanvasLayer/LineEdit
var output_text : String
var leaderboard_service : Node


func _ready():
	$CanvasLayer/Button.grab_focus()
	var leaderboard_service_scene = preload("res://leaderboard_service.tscn")
	leaderboard_service = leaderboard_service_scene.instantiate()

	add_child(leaderboard_service)

func _process(delta: float) -> void:
	if $CanvasLayer/LineEdit.has_focus():
		# Vérifier si une touche spécifique (par exemple "Esc") est pressée pour quitter le focus
		if Input.is_action_just_pressed("ui_text_submit"):
			$CanvasLayer/Button.grab_focus()

func _on_line_edit_text_changed(new_text: String) -> void:
	output_text = new_text


func _on_button_pressed() -> void:
	leaderboard_service.leaderboard = leaderboard_service.load_leaderboard()
	leaderboard_service.add_score(output_text, GameState.current_wave)
	leaderboard_service.print_leaderboard()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
	


func _on_button_2_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
