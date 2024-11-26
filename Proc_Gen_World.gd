extends Node2D

@export var noise_text : NoiseTexture2D
var noise : Noise

var width : int = 400
var height : int = 400

@onready var tile_map = $TileMapLayer

var source_id = 0

@export var current_wave : int = 1
@onready var spawn_Timer : Timer = $Enemy_Spawn_Timer
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

func _process(delta: float) -> void:
	if active_enemies.size() == 0 and spawn_Timer.is_stopped():
		next_wave()

func next_wave():
	# Arrêter le jeu
	get_tree().paused = true
	var upgrade_menu_scene = preload("res://Upgrade_Menu.tscn")
	var upgrade_menu = upgrade_menu_scene.instantiate()

	# Ajouter le menu comme enfant de la scène principale
	add_child(upgrade_menu)

	# Activer la caméra du menu
	var camera = upgrade_menu.get_node("Camera2D")
	camera.make_current()
	current_wave += 1
	print("you leveled up ", player.level_up_count, " times")
	
	player.wave_label.text = "Manche : %d" % current_wave
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
	print("current wave ", current_wave)
	enemies_to_spawn = 5 + current_wave * 2
	enemy_stats["health"] = current_wave * 2
	enemy_stats["damage"] = current_wave
	enemy_stats["speed"] += current_wave * 0.1
	enemy_stats["xp"] +=  current_wave * 0.1
	spawn_Timer.wait_time -= 0.01
	spawn_Timer.start(spawn_Timer.wait_time)

func enemy_spawner():
	var enemy = load("res://enemy.tscn").instantiate()
	enemy.position = get_node("Player").position + Vector2(500, 0).rotated(randf_range(0, 2*PI))
	enemy.health = enemy_stats["health"]
	enemy.damage = enemy_stats["damage"]
	enemy.speed = enemy_stats["speed"]
	add_child(enemy)
	active_enemies.append(enemy)
	enemy.connect("enemy_died", Callable(self, "on_enemy_died"))

func on_enemy_died(enemy):
	active_enemies.erase(enemy)
	

func check_enemy_spawn():
	if enemies_to_spawn > 0:
		enemy_spawner()
		enemies_to_spawn -= 1
	else:
		spawn_Timer.stop()

func _on_timer_timeout() -> void:
	check_enemy_spawn()
