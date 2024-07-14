extends Node2D
var disc_template = preload("res://scenes/Discs/Player Disc Template/PlayerDiscTemplate.tscn")
var peg = preload("res://scenes/Board Obstacles/Peg/Peg.tscn")

var current_disc : Disc = null
const PEG_COUNT = 8

@onready var peg_radius = $Sprite15PT.get_rect().size.x / 2

# Called when the node enters the scene tree for the first time.
func _ready():
	place_pegs(peg_radius, PEG_COUNT)

func _input(event):
	if Input.is_action_just_released("ui_up") and current_disc != null:
		current_disc.apply_central_impulse(($Sprite20PT.position - current_disc.position).normalized().rotated(randf_range(-0.05, 0.05)) * 600)
		current_disc = null
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

func place_pegs(radius, peg_count):
	var step_size = TAU / peg_count
	for angle in Vector3(0.0, TAU, step_size):
		var peg_to_place = peg.instantiate()
		peg_to_place.position = Vector2.RIGHT.rotated(angle + step_size / 2) * radius
		add_child(peg_to_place)



func _on_gutter_area_body_entered(body):
	if body is Disc:
		body.set_collision_mask_value(2, true)
		body.set_collision_mask_value(1, false)
		body.set_collision_layer_value(1, false)
		body.set_collision_layer_value(2, true)
