class_name Disc
extends RigidBody2D

@export var pmass: float = 1
@export var bump_friction: float = 0.6
@export var slide_friction: float = 0.6
@export var rough: bool = false
@export var absorbent: bool = false
@export var bounce: float = 1
@export var title: String = "Template Disc"

var previous_velocity = 0
var touched = false

var freeing_up = false

var inhole_south = false
var inhole_north = false
var inhole_west = false
var inhole_east = false

# Called when the node enters the scene tree for the first time.
func _ready():
	mass = pmass
	physics_material_override.friction = bump_friction
	physics_material_override.rough = rough
	physics_material_override.bounce = bounce
	physics_material_override.absorbent = absorbent
	linear_damp = slide_friction

func get_icon() -> Texture2D:
	return $Sprite2D.texture

func get_disc_name() -> String:
	return title

func _physics_process(_delta):
	touched = false
	previous_velocity = linear_velocity

func _on_body_entered(body):
	print(body)
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


func _on_a_2d_hole_pop_finished():
	print("Freeing this one " + str(self))
	queue_free()
