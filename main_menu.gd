extends Control

var top_players = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
		print("Pas assez de joueurs dans le leaderboard pour afficher les 3 premiers.")


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
