extends Node2D
class_name BattleBoard

##This is a generic numeric value to indicate the intended difficulty of the fight. The battle state manager will end up consuming this when it generates the enemy distribution
var Difficulty : int = -1

var disc_template = preload("res://scenes/Discs/Player Disc Template/PlayerDiscTemplate.tscn")
var peg = preload("res://scenes/Board Obstacles/Peg/Peg.tscn")

var current_disc : Disc = null
var readied_disc : Disc = null
const PEG_COUNT = 8
@onready var bsm = $BattleStateManager

@onready var peg_radius = $Sprite15PT.get_rect().size.x / 2

var physics_done = false
var physics_turn_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if Difficulty == -1:
		#Difficulty = OverworldSingleton.getBattleDifficulty()
		Difficulty = bsm.Difficulty
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

func _input(_event):
	if bsm.state == BattleSM.States.SHOOTDISC and (Input.is_action_just_released("ui_up") or Input.is_action_just_released("click")):
		fire_rdisc(3 * readied_disc.launch_mult * (
			-readied_disc.position + 
			get_local_mouse_position()
			 ))
	elif bsm.state == BattleSM.States.ENDCOMBAT and (Input.is_action_just_released("ui_up") or Input.is_action_just_released("click")):
		get_tree().reload_current_scene()
	
	if bsm.state == BattleSM.States.PLACEDISC and Input.is_action_just_released("click"):
		$PlaceableArea.flash_area()

func _on_edge_area_2d_input_event(_viewport, event, shape_idx):
	if Input.is_action_just_released("click") and bsm.state == BattleSM.States.PLACEDISC:
		place_rdisc(get_global_transform_with_canvas().affine_inverse() * event.position)

func place_pegs(radius, peg_count):
	var step_size = TAU / peg_count
	for angle in Vector3(0.0, TAU, step_size):
		var peg_to_place = peg.instantiate()
		peg_to_place.position = Vector2.RIGHT.rotated(angle + step_size / 2) * radius
		add_child(peg_to_place)

func _physics_process(_delta):
	if bsm.state == BattleSM.States.SHOTPHYSICSRUNNING:
		var physics_seems_done = true
		for body in get_children():
			if body is Disc:
				#print(str(body) + " is doin' " + str(body.linear_velocity) + " and issit zero? Well, " + str(body.sleeping))
				if not body.sleeping and not body.guttered:
					physics_seems_done = false
					break
		if physics_seems_done and physics_turn_count > 0:
			physics_turn_count -= 1
		elif physics_seems_done and physics_turn_count == 0:
			bsm.ready_for_enemy.emit()
			physics_done = true
		else:
			physics_done = false
			physics_turn_count = 5

func _on_gutter_area_body_entered(body):
	if body is Disc:
		body.collision_mask = 2
		body.collision_layer = 2
		body.guttered = true


func _on_battle_state_manager_ready_for_physics():
	physics_done = false
	physics_turn_count = 5
