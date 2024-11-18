extends Node2D

@export var noise_text : NoiseTexture2D
var noise : Noise

var width : int = 400
var height : int = 400

@onready var tile_map = $TileMapLayer

var source_id = 0

var wave : int = 1

func _ready() -> void:
	noise = noise_text.noise
	generate_world()
	enemy_spawner()


func generate_world():
	for x in range(width):
		for y in range(height):
			var noise_val : float = noise.get_noise_2d(x, y)
			if noise_val > 0.0:
				tile_map.set_cell(Vector2(x, y), source_id, Vector2(randi_range(0, 3), randi_range(8, 15)))
			elif noise_val < 0.0:
				tile_map.set_cell(Vector2(x, y), source_id, Vector2(randi_range(0, 15), randi_range(0, 7)))


func enemy_spawner():
	var enemy = load("res://enemy.tscn").instantiate()
	add_child(enemy)
	enemy.position = get_node("Player").position + Vector2(500, 0).rotated(randf_range(0, 2*PI))


func _on_timer_timeout() -> void:
	enemy_spawner()
