extends Sprite2D
class_name Seasonal5PTSegment

@export_enum("SPRING", "SUMMER", "FALL", "WINTER") var season : int


func get_season():
	return season


func _on_area_2d_body_entered(body):
	if body is Disc and season == 3:
		#print(str(body) + " is getting spinny")
		#body.apply_torque_impulse(1500)
		pass
