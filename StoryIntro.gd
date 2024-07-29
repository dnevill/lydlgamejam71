extends Control

var impatientCount = 0

func _ready():
	$Anim.play("introscene/intro_scene");

func _input(event):
	if event.is_action("click"):
		impatientCount += 1
		if impatientCount > 2:
			$Anim.stop()
			SceneLoader.load_scene("res://scenes/Overworld/Overworld.tscn");

func _on_anim_animation_finished(_anim_name):
	SceneLoader.load_scene("res://scenes/Overworld/Overworld.tscn");
