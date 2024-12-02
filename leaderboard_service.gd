extends Node

const SAVE_PATH = "res://assets/Save file/Leaderboard.json"
var leaderboard = []

func load_leaderboard() -> Array:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var content = file.get_as_text()
			file.close()
			var parsed_result = JSON.parse_string(content)
			if typeof(parsed_result) == TYPE_ARRAY:  # Si c'est directement un tableau
				return parsed_result
			elif typeof(parsed_result) == TYPE_DICTIONARY and parsed_result.has("data"):
				return parsed_result["data"]
			else:
				print("Erreur : le fichier JSON n'est ni un tableau ni un dictionnaire valide.")
	print("Aucun fichier trouvé ou le contenu est invalide. Utilisation du leaderboard par défaut.")
	return leaderboard  # Retourne la liste par défaut en cas de problème

func save_leaderboard():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(leaderboard))
		file.close()
		print("Leaderboard sauvegardé avec succès.")
	else:
		print("Erreur : impossible de sauvegarder le leaderboard.")

func add_score(player_name: String, wave: int):
	leaderboard.append({"name": player_name, "manche": wave})
	if leaderboard.size() > 10:
		leaderboard = leaderboard.slice(0, 10)
	save_leaderboard()

func get_top_entries() -> Array:
	if leaderboard.size() == 0:
		print("Le leaderboard est vide.")
		return []
	
	leaderboard.sort_custom(_sort_scores)
	return leaderboard.slice(0, 3)

func _sort_scores(a, b):
	return b["manche"] - a["manche"]

func print_leaderboard():
	print("=== Leaderboard ===")
	leaderboard.sort_custom(_sort_scores)
	for entry in leaderboard:
		print(entry["name"] + ": " + str(entry["manche"]))
