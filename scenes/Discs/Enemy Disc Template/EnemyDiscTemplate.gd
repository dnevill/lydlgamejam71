extends Disc
class_name EnemyDisc

var taking_turn = false
var turn_count = 0
signal turn_finished
signal freed_up(myself)
var intended_turn : Vector2
var intended_turn_impact : Vector2

@export var Difficulty_Score : int = 1

var initial_polygon = false

func prepare_next_turn():
	#print("preparing line")
	intended_turn = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * randf_range(20, 100)
	$Polygon2D.rotation = intended_turn.angle()
	$Polygon2D.visible = true


func take_turn():
	#print(str(title)  + str(self) + " is taking its turn")
	if not taking_turn:
		apply_central_impulse(intended_turn.rotated($".".rotation))
		$Polygon2D.visible = false
		taking_turn = true
		turn_count = 5

func _physics_process(_delta):
	if not initial_polygon:
		prepare_next_turn()
		initial_polygon = true
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
