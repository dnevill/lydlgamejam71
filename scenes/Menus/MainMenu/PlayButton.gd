extends Button



func _on_pressed():
	PSM.reset_player()
	OverworldSingleton.pendingSeasonAdvancement = 0
	OverworldSingleton.mapPopulate()
	pass
