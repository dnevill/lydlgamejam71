class_name HealingDisc
extends Disc

var collision_combo : int = 1

func _on_body_entered(body):
	#print(body)
	if not guttered and (body is Disc or body is Peg):
		PSM.heal(collision_combo, position)
		collision_combo *= 2
	
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


func _on_sleeping_state_changed():
	collision_combo = 1
