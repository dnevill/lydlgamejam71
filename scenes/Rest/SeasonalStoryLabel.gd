extends Label
@export_enum("SPRING", "SUMMER", "FALL", "WINTER") var season : int

# Called when the node enters the scene tree for the first time.
func _ready():
	if season == OverworldSingleton.getSeason():
		visible = true

