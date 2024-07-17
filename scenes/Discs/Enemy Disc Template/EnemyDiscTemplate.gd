extends Disc
class_name EnemyDisc

var taking_turn = false
var turn_count = 0
signal turn_finished

func take_turn():
	#print(str(title)  + str(self) + " is taking its turn")
	if not taking_turn:
		apply_impulse(Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * randf_range(20, 100))
		taking_turn = true
		turn_count = 5

func _physics_process(_delta):
	if taking_turn and sleeping and turn_count > 0:
		turn_count -= 1
	elif taking_turn and sleeping and turn_count == 0:
		#print(str(title)  + str(self) + " is done with its turn")
		taking_turn = false
		turn_finished.emit()

func score(score : int):
	PSM.damage(score * score_mult, position)
	queue_free()
	return true
