extends Disc
class_name EnemyDisc

var taking_turn = false
var turn_count = 0
signal turn_finished
signal freed_up(myself)

@export var Difficulty_Score : int = 1

func take_turn():
	#print(str(title)  + str(self) + " is taking its turn")
	if not taking_turn:
		apply_impulse(Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * randf_range(20, 100))
		taking_turn = true
		turn_count = 5

func _physics_process(_delta):
	if taking_turn and linear_velocity.length() < 5 and turn_count > 0:
		turn_count -= 1
	elif taking_turn and linear_velocity.length() < 5 and turn_count == 0:
		#print(str(title)  + str(self) + " is done with its turn")
		taking_turn = false
		turn_finished.emit()
	#elif taking_turn and not linear_velocity.length() > 5:
		#print(str(self) + " is still busy y'all at position " + str(position))
	if position.x == NAN or position.y == NAN or str(position) == "(nan, nan)":
		print("a disc got blasted to infinity, removing")
		guttered = true
		if taking_turn: turn_finished.emit()
		freed_up.emit(self)
		queue_free()


func score(scoreAmt : int):
	PSM.damage(scoreAmt * score_mult, position)
	queue_free()
	return true
