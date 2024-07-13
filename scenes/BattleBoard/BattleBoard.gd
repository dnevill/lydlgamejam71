extends Node2D
var disc_template = preload("res://scenes/Discs/Player Disc Template/PlayerDiscTemplate.tscn")

var current_disc : Disc = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if Input.is_action_just_released("ui_up"):
		current_disc.apply_central_impulse(($Sprite20PT.position - current_disc.position).normalized() * 600)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			var enemydisc = disc_template.instantiate()
			enemydisc.position = get_global_transform_with_canvas().affine_inverse() * event.position
			enemydisc.get_node("Sprite2D").modulate = Color(0.2,0.2,0.9)
			add_child(enemydisc)

func _on_edge_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			current_disc = disc_template.instantiate()
			current_disc.position = get_global_transform_with_canvas().affine_inverse() * event.position
			add_child(current_disc)



