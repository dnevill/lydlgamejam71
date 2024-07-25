extends Label
class_name FlyLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	update_label()


func update_label():
	text = str(PSM.Flies)

func update_labels():
	update_label()
	$"../EScore".update_label()
