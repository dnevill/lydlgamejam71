class_name Disc
extends RigidBody2D

@export var pmass: float = 1
@export var bump_friction: float = 0.6
@export var slide_friction: float = 0.6
@export var rough: bool = false
@export var absorbent: bool = false
@export var bounce: float = 1

var previous_velocity = 0
var touched = false

# Called when the node enters the scene tree for the first time.
func _ready():
	mass = pmass
	physics_material_override.friction = bump_friction
	physics_material_override.rough = rough
	physics_material_override.bounce = bounce
	physics_material_override.absorbent = absorbent
	linear_damp = slide_friction

func _physics_process(_delta):
	touched = false
	previous_velocity = linear_velocity

func _on_body_entered(body):
	print(body)
	if not touched:
		print("We not touched yet")
		if typeof(body) == typeof(Disc):
			var dbody : Disc = body
			dbody.touched = true
		var impulse = Vector2(linear_velocity - previous_velocity).length_squared()
		const min_pitch = 1
		const max_pitch = 1.4
		const min_impulse = 0
		const max_impulse = 300000
		const max_dB = 20
		const min_dB = -20
		var new_pitch = clampf(remap(impulse,min_impulse, max_impulse, min_pitch, max_pitch),min_pitch, max_pitch)
		var new_volume = clampf(remap(impulse,min_impulse, max_impulse, min_dB, max_dB),min_dB, max_dB)
		print(str(impulse) + " vol: " + str(new_volume) + " pitch: " + str(new_pitch))
		$AudioStreamPlayer2D.pitch_scale = new_pitch
		$AudioStreamPlayer2D.volume_db = new_volume
		$AudioStreamPlayer2D.play()
