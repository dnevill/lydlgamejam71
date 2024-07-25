extends Control

func _ready():
	$Anim.play("introscene/intro_scene");

func _on_anim_animation_finished(_anim_name):
	SceneLoader.load_scene("res://scenes/Overworld/Overworld.tscn");
