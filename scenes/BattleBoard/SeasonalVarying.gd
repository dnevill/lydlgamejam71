extends Sprite2D

@export var SpringTexture : Texture2D
@export var SummerTexture : Texture2D
@export var FallTexture : Texture2D
@export var WinterTexture : Texture2D

func _on_season_update(season : int):
	match season:
		OverworldManager.SEASON_SPRING:
			texture = SpringTexture
		OverworldManager.SEASON_SUMMER:
			texture = SummerTexture
		OverworldManager.SEASON_AUTUMN:
			texture = FallTexture
		OverworldManager.SEASON_WINTER:
			texture = WinterTexture


func _on_season_detector_season_changed(season):
	_on_season_update(season)
