extends Node2D

@export var noise_text : NoiseTexture2D
var noise : Noise

var width : int = 400
var height : int = 400

@onready var tile_map = $TileMapLayer

var source_id = 0

@export var current_wave : int = 1
@onready var spawn_Timer : Timer = $Enemy_Spawn_Timer
@onready var round_duration_Timer : Timer = $Round_Duration
var enemy_spawn_speed : float = 1
var enemies_to_spawn : int
var ennemies_left : int
var enemy_stats = {
	"health": 5,
	"damage": 2,
	"speed": 3,
	"xp": 1
}

var active_enemies = []

var player : CharacterBody2D
signal player_ready(player)

func _ready() -> void:
	noise = noise_text.noise
	player = get_node("Player") 
	emit_signal("player_ready", $Player)
	generate_world()
	start_wave()
	$AudioStreamPlayer.play()


func _process(delta: float) -> void:
	player.time_left_label.text = "Temps restant : %.1f" % round_duration_Timer.time_left


func next_wave():
	# Arrêter le jeu
	spawn_Timer.stop()
	round_duration_Timer.stop()
	for enemy in active_enemies:
		enemy.queue_free()  # Supprime l'ennemi de la scène
	active_enemies.clear()
	if player.level_up_count > 0:
		get_tree().paused = true
		var upgrade_menu_scene = preload("res://Upgrade_Menu.tscn")
		var upgrade_menu = upgrade_menu_scene.instantiate()

		# Ajouter le menu comme enfant de la scène principale
		add_child(upgrade_menu)

		# Activer la caméra du menu
		var camera = upgrade_menu.get_node("Camera2D")
		camera.make_current()
	
	await get_tree().create_timer(2).timeout
	current_wave += 1
	
	player.wave_label.text = "Manche : %d" % current_wave
	player.health = player.max_health
	player.hp_bar.update_value(player.max_health, player.max_health)
	player.level_up_count = 0
	start_wave()

func generate_world():
	for x in range(width):
		for y in range(height):
			var noise_val : float = noise.get_noise_2d(x, y)
			if noise_val > 0.0:
				tile_map.set_cell(Vector2(x, y), source_id, Vector2(randi_range(0, 3), randi_range(8, 15)))
			elif noise_val < 0.0:
				tile_map.set_cell(Vector2(x, y), source_id, Vector2(randi_range(0, 15), randi_range(0, 7)))

func start_wave():
	enemy_stats["damage"] = current_wave + 4
	if current_wave < 15:
		enemy_stats["health"] = current_wave * 2
		spawn_Timer.wait_time -= 0.025
		enemy_stats["speed"] = 3
		enemy_stats["speed"] += current_wave * 0.13
	elif current_wave > 10 && current_wave < 15:
		print("test")
		enemy_stats["health"] *= 3
	else:	
		enemy_stats["health"] += current_wave * 20
	enemy_stats["xp"] = 1
	enemy_stats["xp"] +=  current_wave * 0.1
	round_duration_Timer.start(round_duration_Timer.wait_time)
	spawn_Timer.start(spawn_Timer.wait_time)

func enemy_spawner():
	var enemy = load("res://enemy.tscn").instantiate()
	enemy.position = get_node("Player").position + Vector2(randf_range(500, 1500), 0).rotated(randf_range(0, 2*PI))
	enemy.health = enemy_stats["health"]
	enemy.damage = enemy_stats["damage"]
	enemy.speed = enemy_stats["speed"]
	enemy.xp = enemy_stats["xp"]
	add_child(enemy)
	active_enemies.append(enemy)
	enemy.connect("damage_received", Callable(self, "_on_enemy_damage_received"))
	enemy.connect("enemy_died", Callable(self, "on_enemy_died"))

func _on_enemy_damage_received(amount, position):
	# Créer le label pour afficher les dégâts
	var damage = Label.new()
	damage.text = str(amount)
	damage.label_settings = LabelSettings.new()
	damage.label_settings.font_size = 32
	damage.label_settings.font = preload("res://assets/Fonts/Super Shiny.ttf")

	# Ajouter le label au World
	add_child(damage)
	damage.global_position = position
	
	var tween = create_tween()
	tween.tween_property(damage, "position", damage.position + Vector2(randf_range(-75, 75), -30), 0.5) 
	tween.tween_property(damage, "modulate:a", 0, 0.5)
	

	
	await tween.finished
	damage.queue_free()  

func on_enemy_died(enemy):
	active_enemies.erase(enemy)
	

func _on_timer_timeout() -> void:
	enemy_spawner()


func _on_round_duration_timeout() -> void:
	next_wave()
