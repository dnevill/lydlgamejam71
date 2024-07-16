extends Disc
class_name GhostDisc

var ghost_mode = true

func _on_body_entered(body):
	#print(body)
	if ghost_mode:
		if body is EnemyDisc and not body.is_player_disc:
			print(str(body) + str(body.title) + " turned me out of ghost mode")
			ghost_mode = false
			set_collision_layer_value(1, true)
			set_collision_mask_value(1, true)
			set_collision_mask_value(3, true)
			$A2DUnGhost.play()
		else:
			$A2DGhostGlide.play()
	if not touched and not ghost_mode:
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
	if not freeing_up and not ghost_mode:
		var hole : int = int(inhole_north) + int(inhole_south) + int(inhole_east) + int(inhole_west)
		#print(hole)
		if hole > 2:
			went_in_hole.emit(self)
			#print("Playing pop noise from " + str(self))
			freeing_up = true
			$A2DHolePop.play()
