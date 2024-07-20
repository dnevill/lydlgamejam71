extends Node2D
class_name FivePointRegions

var _season

const HALF_SEAS_SPAN = 45
const SPRING_ANG = 45
const WINT_ANG = SPRING_ANG + 90
const FALL_ANG = WINT_ANG + 90
const SUM_ANG = FALL_ANG + 90
var number_of_full_spins_before_set = 2
signal new_season_aligned(season : int)

var current_season_anim : int = OverworldManager.SEASON_SPRING

var current_rotation : int:
	get:
		return current_rotation
	set(value):
		rotation_degrees = value
		current_rotation = value
		if _check_season_degrees(value) != current_season_anim:
			#print(str(value) + " is just " + str(value % 360))
			current_season_anim = _check_season_degrees(value)
			new_season_aligned.emit(current_season_anim)
		
		


func _check_season_degrees(value):
	var modulo = (value + HALF_SEAS_SPAN) % 360
	if modulo > SPRING_ANG and modulo <= WINT_ANG:
		return OverworldManager.SEASON_SPRING
	elif modulo > WINT_ANG and modulo <= FALL_ANG:
		return OverworldManager.SEASON_WINTER
	elif modulo > FALL_ANG and modulo <= SUM_ANG:
		return OverworldManager.SEASON_AUTUMN
	else: return OverworldManager.SEASON_SUMMER

# Called when the node enters the scene tree for the first time.
func _ready():
	_season = OverworldSingleton.getSeason()
	var target_rotation = SPRING_ANG
	match _season:
		OverworldSingleton.SEASON_SPRING:
			target_rotation = SPRING_ANG
		OverworldSingleton.SEASON_SUMMER:
			target_rotation = SUM_ANG
		OverworldSingleton.SEASON_AUTUMN:
			target_rotation = FALL_ANG
		OverworldSingleton.SEASON_WINTER:
			target_rotation = WINT_ANG
	current_rotation = target_rotation - 180
	var tween = get_tree().create_tween()
	tween.tween_property(self, "current_rotation", number_of_full_spins_before_set * 360 + target_rotation, 2.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_callback($"../BattleStateManager".populate_enemies)
	

	
