extends Control

func _ready():
	$Anim.play("finalcutscene");

func _on_anim_animation_finished(_anim_name):
	SceneLoader.load_scene("res://scenes/BattleBoard/BattleBoard.tscn");
