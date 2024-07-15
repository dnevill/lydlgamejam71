extends Node2D
var disc_template = preload("res://scenes/Discs/Player Disc Template/PlayerDiscTemplate.tscn")
var peg = preload("res://scenes/Board Obstacles/Peg/Peg.tscn")

var current_disc : Disc = null
var readied_disc : Disc = null
const PEG_COUNT = 8
@onready var bsm = $BattleStateManager

@onready var peg_radius = $Sprite15PT.get_rect().size.x / 2

var maybe_physics_done = false

# Called when the node enters the scene tree for the first time.
func _ready():
	place_pegs(peg_radius, PEG_COUNT)
	print("Player has " + str(PSM.Health) + " of " + str(PSM.MaxHealth) + " health and " + str(PSM.Flies) + " flies")

func ready_disc(disc : Disc):
	readied_disc = disc

func place_rdisc(postoplace : Vector2):
	if readied_disc != null and bsm.state == BattleSM.States.PLACEDISC:
		readied_disc.position = postoplace
		add_child(readied_disc)
		bsm.ready_to_shoot.emit()
		
func fire_rdisc(impulse: Vector2):
	if readied_disc != null and bsm.state == BattleSM.States.SHOOTDISC:
		readied_disc.apply_central_impulse(impulse)
		readied_disc = null
		bsm.ready_for_physics.emit()

func _input(event):
	if Input.is_action_just_released("ui_up"):
		fire_rdisc(($Sprite20PT.position - get_local_mouse_position()).normalized().rotated(randf_range(-0.05, 0.05)) * 600)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		var enemydisc = disc_template.instantiate()
		enemydisc.position = get_global_transform_with_canvas().affine_inverse() * event.position
		enemydisc.get_node("Sprite2D").modulate = Color(0.2,0.2,0.9)
		add_child(enemydisc)

func _on_edge_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and bsm.state == BattleSM.States.PLACEDISC:
		place_rdisc(get_global_transform_with_canvas().affine_inverse() * event.position)

func place_pegs(radius, peg_count):
	var step_size = TAU / peg_count
	for angle in Vector3(0.0, TAU, step_size):
		var peg_to_place = peg.instantiate()
		peg_to_place.position = Vector2.RIGHT.rotated(angle + step_size / 2) * radius
		add_child(peg_to_place)

func _physics_process(delta):
	#TODO This whooole mess is jank and sometimes we go right back to 'choose disc'
	if bsm.state == BattleSM.States.SHOTPHYSICSRUNNING:
		var physics_done = true
		for body in get_children():
			if body is RigidBody2D:
				#print(str(body) + " is doin' " + str(body.linear_velocity) + " and issit zero? Well, " + str(body.sleeping))
				if not body.sleeping:
					physics_done = false
					break
		if physics_done and not maybe_physics_done:
			maybe_physics_done = true
		elif physics_done and maybe_physics_done:
			bsm.ready_for_enemy.emit()
		else:
			maybe_physics_done = false

func _on_gutter_area_body_entered(body):
	if body is Disc:
		body.set_collision_mask_value(2, true)
		body.set_collision_mask_value(1, false)
		body.set_collision_layer_value(1, false)
		body.set_collision_layer_value(2, true)
