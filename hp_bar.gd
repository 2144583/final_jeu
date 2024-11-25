extends TextureProgressBar


@onready var text : Label = $HP_Label

func update_value (new_value : int, max : int):
	max_value = max
	value = new_value
	text.text = "HP: %d / %d" % [int(value), int(max)]
