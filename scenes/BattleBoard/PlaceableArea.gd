extends Area2D
class_name PlaceableArea

func flash_area():
	await get_tree().create_timer(0.25).timeout
	if $"../BattleStateManager".state == $"../BattleStateManager".States.PLACEDISC:
		var tween = get_tree().create_tween()
		tween.tween_property($Polygon2D, "color:a", 1.0, 0.5)
		tween.tween_property($Polygon2D, "color:a", 0.0, 0.5)
		tween.tween_property($Polygon2D, "color:a", 1.0, 0.5)
		tween.tween_property($Polygon2D, "color:a", 0.0, 0.5)

