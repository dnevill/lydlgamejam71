extends Control
class_name DiscInventoryLabel
var discobject : Disc
signal discselected(discobject, myself)

# Called when the node enters the scene tree for the first time.
func _ready():
	if discobject != null:
		$Label/TextureRect.texture = discobject.get_icon()
		$Label/TextureRect.modulate = discobject.get_node("Sprite2D").modulate
		$Label/TextureRect.material = discobject.get_node("Sprite2D").material
		$Label.text = discobject.get_disc_name()
		
	else:
		$Label.text = "Missing Disc"

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		discselected.emit(discobject, self)
