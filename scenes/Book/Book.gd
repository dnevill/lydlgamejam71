extends Control

func _ready():
	$PageOne/Story.text = "This is a story.\n\nIt represents a scenario where you must make a choice.";
	$PageOne/Option1Btn.text = "Do first thing.";
	$PageOne/Option2Btn.text = "Do second thing.";
	$PageOne/Option3Btn.text = "Do nothing.";

func _turnPage():
	$PageOne.visible = false;
	$PageTwo.visible = true;

func _on_option_1_btn_pressed():
	$PageTwo/Result.text = "The first thing was done.";
	$PageTwo/Consequence.text = "You feel bad.";
	_turnPage();

func _on_option_2_btn_pressed():
	$PageTwo/Result.text = "The second thing was done.";
	$PageTwo/Consequence.text = "You feel good.";
	_turnPage();

func _on_option_3_btn_pressed():
	$PageTwo/Result.text = "Nothing was done.";
	$PageTwo/Consequence.text = "Nothing happened.";
	_turnPage();

func _on_leave_btn_pressed():
	SceneLoader.load_scene("res://scenes/Overworld/Overworld.tscn");
