class_name Disc
extends RigidBody2D

@export var pmass: float = 1
@export var bump_friction: float = 0.6
@export var slide_friction: float = 0.6
@export var rough: bool = false
@export var absorbent: bool = false
@export var bounce: float = 1
@export var title: String = "Template Disc"
@export var is_player_disc = true
@export var launch_mult : float = 1.0
@export var score_mult : float = 1.0
@export var healing_mult : float = 0.0

var previous_velocity : Vector2 = Vector2(0,0)
var touched = false

var freeing_up = false

var inhole_south = false
var inhole_north = false
var inhole_west = false
var inhole_east = false

var guttered = false

signal went_in_hole(ref_to_self)

var _enabled_collision_layers
var _enabled_collision_mask
var collision_enabled = true


## Toggles collisions relative to the current layers and mask at the time it was toggled off
func toggle_collision():
	#print("The disc collision is switching from " + str(collision_enabled))
	await get_tree().create_timer(0.1).timeout
	if collision_enabled:
		_enabled_collision_layers = collision_layer
		_enabled_collision_mask = collision_mask
		collision_layer = 0
		collision_mask = 0
		set_collision_layer_value(8, true)
		set_collision_mask_value(8, true)
		collision_enabled = false
	else:
		collision_layer = _enabled_collision_layers
		collision_mask = _enabled_collision_mask
		collision_enabled = true
	#print(str(collision_layer) + " " + str(collision_mask))

# Called when the node enters the scene tree for the first time.
func _ready():
	mass = pmass
	physics_material_override.friction = bump_friction
	physics_material_override.rough = rough
	physics_material_override.bounce = bounce
	physics_material_override.absorbent = absorbent
	linear_damp = slide_friction

func score(scoreAmt : int):
	PSM.add_flies(scoreAmt * score_mult, position + Vector2.RIGHT * 40)
	PSM.heal(scoreAmt * healing_mult, position + Vector2.LEFT * 40)
	queue_free()
	return true

func get_icon() -> Texture2D:
	return $Sprite2D.texture

func get_disc_name() -> String:
	return title

func get_sprite2d() -> Sprite2D:
	return $Sprite2D

func _physics_process(_delta):
	touched = false
	previous_velocity = linear_velocity

func _on_body_entered(body):
	#print(body)
	if not touched:
		#print("We not touched yet")
		var impulse = Vector2(linear_velocity - previous_velocity).length_squared()
		const min_pitch = 1
		const max_pitch = 1.4
		const min_impulse = 0
		const max_impulse = 300000
		const max_dB = 20
		const min_dB = -20
		var new_pitch = clampf(remap(impulse,min_impulse, max_impulse, min_pitch, max_pitch),min_pitch, max_pitch)
		var new_volume = clampf(remap(impulse,min_impulse, max_impulse, min_dB, max_dB),min_dB, max_dB)
		#print(str(impulse) + " vol: " + str(new_volume) + " pitch: " + str(new_pitch))
		if body is Peg:
			#print(body.name)
			$A2DPegHit.pitch_scale = new_pitch
			$A2DPegHit.volume_db = new_volume
			$A2DPegHit.play()
		else:
			#print(body.name)
			$A2DChockHit.pitch_scale = new_pitch
			$A2DChockHit.volume_db = new_volume
			$A2DChockHit.play()
			if body is Disc:
				var dbody : Disc = body
				dbody.touched = true


func check_pop():
	if not freeing_up:
		var hole : int = int(inhole_north) + int(inhole_south) + int(inhole_east) + int(inhole_west)
		#print(hole)
		if hole > 2:
			went_in_hole.emit(self)
			#print("Playing pop noise from " + str(self))
			freeing_up = true
			$A2DHolePop.play()

func _on_overlap_check_s_area_entered(area):
	if area is Hole20Area:
		inhole_south = true
		check_pop()

func _on_overlap_check_s_area_exited(area):
	if area is Hole20Area:
		inhole_south = false

func _on_overlap_check_n_area_entered(area):
	if area is Hole20Area:
		inhole_north = true
		check_pop()

func _on_overlap_check_n_area_exited(area):
	if area is Hole20Area:
		inhole_north = false
		
func _on_overlap_check_w_area_entered(area):
	if area is Hole20Area:
		inhole_west = true
		check_pop()

func _on_overlap_check_w_area_exited(area):
	if area is Hole20Area:
		inhole_west = false
		
func _on_overlap_check_e_area_entered(area):
	if area is Hole20Area:
		inhole_east = true
		check_pop()

func _on_overlap_check_e_area_exited(area):
	if area is Hole20Area:
		inhole_east = false


#func _on_a_2d_hole_pop_finished():
	#print("Freeing this disc it went in the hole " + title + " " + str(self))
	#queue_free()
