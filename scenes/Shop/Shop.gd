extends Control

func _labelUpdate():
	$FLabel.text = "Flies: " + str(PSM.Flies);
func _ready():
	_labelUpdate();

func _process(_delta):
	pass

func _on_leave_btn_pressed():
	SceneLoader.load_scene("res://scenes/Overworld/Overworld.tscn");
	
func _on_item_1_btn_pressed():
	if PSM.spend_flies(20, $Item1Btn.position):
		$Item1Btn.visible = false;
		PSM.giveBasicDisc();
		_labelUpdate();

func _on_item_2_btn_pressed():
	if PSM.spend_flies(50, $Item2Btn.position):
		$Item2Btn.visible = false;
		PSM.giveHeavyDisc();
		_labelUpdate();

func _on_item_3_btn_pressed():
	if PSM.spend_flies(50, $Item3Btn.position):
		$Item3Btn.visible = false;
		PSM.giveHeavyDisc();
		_labelUpdate();
