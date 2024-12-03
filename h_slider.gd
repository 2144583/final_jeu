extends HSlider


const BASE_VALUE = 1
@export var bus_name: String

var bus_index: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = ProjectSettings.get_setting("user_settings/%s_slider_value" % bus_name, BASE_VALUE)
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)

func _unhandled_input(event):
	if not has_focus(): 
		return  # Ne rien faire si le slider n'a pas le focus

	if event.is_action_pressed("ui_left"):  # Touche gauche ou personnalisation
		value -= step
	elif event.is_action_pressed("ui_right"):  # Touche droite ou personnalisation
		value += step
	elif event.is_action_pressed("ui_up"):  # Touche haut
		value += step
	elif event.is_action_pressed("ui_down"):  # Touche bas
		value -= step
	# Limiter la valeur entre min et max
	value = clamp(value, min_value, max_value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_value_changed(value: float) -> void:
	# Enregistrer la valeur dans les propriétés utilisateur
	ProjectSettings.set_setting("user_settings/%s_slider_value" % bus_name, value)
	ProjectSettings.save()

	# Mettre à jour le volume audio
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
