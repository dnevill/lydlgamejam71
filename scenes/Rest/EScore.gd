extends Label
class_name HealthLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	update_label()


func update_label():
	text = str(PSM.Health) + "/" + str(PSM.MaxHealth)

