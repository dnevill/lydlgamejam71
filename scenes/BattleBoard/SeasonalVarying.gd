extends Sprite2D

@export var SpringTexture : Texture2D
@export var SummerTexture : Texture2D
@export var FallTexture : Texture2D
@export var WinterTexture : Texture2D

func _on_season_update(season : int):
	match season:
		OverworldManager.SEASON_SPRING:
			texture = SpringTexture
			$Area2D.linear_damp_space_override = $"../5PTRegions/Sprite5PTSpring/Area2D".linear_damp_space_override
			$Area2D.linear_damp = $"../5PTRegions/Sprite5PTSpring/Area2D".linear_damp
			$Area2D.angular_damp_space_override = $"../5PTRegions/Sprite5PTSpring/Area2D".angular_damp_space_override
			$Area2D.angular_damp = $"../5PTRegions/Sprite5PTSpring/Area2D".angular_damp
		OverworldManager.SEASON_SUMMER:
			texture = SummerTexture
			$Area2D.linear_damp_space_override = $"../5PTRegions/Sprite5PTSummer/Area2D".linear_damp_space_override
			$Area2D.linear_damp = $"../5PTRegions/Sprite5PTSummer/Area2D".linear_damp
			$Area2D.angular_damp_space_override = $"../5PTRegions/Sprite5PTSummer/Area2D".angular_damp_space_override
			$Area2D.angular_damp = $"../5PTRegions/Sprite5PTSummer/Area2D".angular_damp
		OverworldManager.SEASON_AUTUMN:
			texture = FallTexture
			$Area2D.linear_damp_space_override = $"../5PTRegions/Sprite5PTFall/Area2D".linear_damp_space_override
			$Area2D.linear_damp = $"../5PTRegions/Sprite5PTFall/Area2D".linear_damp
			$Area2D.angular_damp_space_override = $"../5PTRegions/Sprite5PTFall/Area2D".angular_damp_space_override
			$Area2D.angular_damp = $"../5PTRegions/Sprite5PTFall/Area2D".angular_damp
		OverworldManager.SEASON_WINTER:
			texture = WinterTexture
			$Area2D.linear_damp_space_override = $"../5PTRegions/Sprite5PTWinter/Area2D".linear_damp_space_override
			$Area2D.linear_damp = $"../5PTRegions/Sprite5PTWinter/Area2D".linear_damp
			$Area2D.angular_damp_space_override = $"../5PTRegions/Sprite5PTWinter/Area2D".angular_damp_space_override
			$Area2D.angular_damp = $"../5PTRegions/Sprite5PTWinter/Area2D".angular_damp


func _on_season_detector_season_changed(season):
	_on_season_update(season)
