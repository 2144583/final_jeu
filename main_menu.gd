extends Control

var top_players = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ButtonContainer/Play_Button.grab_focus()
	var leader_board_service_scene = preload("res://leaderboard_service.tscn")
	var leader_board_service = leader_board_service_scene.instantiate()
	add_child(leader_board_service)
	
	leader_board_service.leaderboard = leader_board_service.load_leaderboard()

	var top_players = leader_board_service.get_top_entries()

	if top_players.size() >= 3:
		$LeaderboardContainer.get_child(0).text = top_players[0]["name"] + ": manche " + str(top_players[0]["manche"])
		$LeaderboardContainer.get_child(1).text = top_players[1]["name"] + ": manche " + str(top_players[1]["manche"])
		$LeaderboardContainer.get_child(2).text = top_players[2]["name"] + ": manche " + str(top_players[2]["manche"])
	else:
		$LeaderboardContainer/place2.text = "pas assez de scores pour le leaderboard"


func is_on_arcade() -> bool:
	return OS.get_executable_path().to_lower().contains("retropie")

func manage_end_game() -> void:
	if is_on_arcade() :
		if Input.is_action_pressed("Hotkey") and Input.is_action_pressed("Quit"):
			get_tree().quit()
	else :
		if Input.is_action_just_pressed("Quit"):
			get_tree().quit()

func _process(_delta: float) -> void:
	manage_end_game()
	$AnimationPlayer.play("menu")
	

func _on_button_pressed() -> void:
	$AudioStreamPlayer.stop()
	get_tree().change_scene_to_file("res://world.tscn")


func _on_settings_button_pressed() -> void:
	var settings_menu_scene = preload("res://settings_menu.tscn")
	var settings_menu = settings_menu_scene.instantiate()
	settings_menu.parent_menu = $ButtonContainer/Play_Button

	# Ajouter le menu comme enfant de la scène principale
	add_child(settings_menu)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
