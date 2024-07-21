extends Control
class_name Book

@export var StoryDesc : String = "This is a story.\n\nIt represents a scenario where you must make a choice."
@export var ButtonOneText : String = "Do first thing."
@export var ButtonTwoText : String = "Do second thing."
@export var ButtonThreeText : String = "Do nothing."

@export var OptOneResult : String = "The first thing was done."
@export var OptOneConsequence : String = "You feel bad."

@export var OptTwoResult : String = "The second thing was done."
@export var OptTwoConsequence : String = "You feel good."

@export var OptThreeResult : String = "Nothing was done."
@export var OptThreeConsequence : String = "Nothing happened."

@export_file("*.tscn") var exit_scene_path : String = "res://scenes/Overworld/Overworld.tscn"

func _ready():
	$PageOne/Story.text = StoryDesc
	$PageOne/Option1Btn.text = ButtonOneText
	$PageOne/Option2Btn.text = ButtonTwoText
	$PageOne/Option3Btn.text = ButtonThreeText

func _turnPage():
	$PageOne.visible = false;
	$PageTwo.visible = true;

func _on_option_1_btn_pressed():
	$PageTwo/Result.text = OptOneResult
	$PageTwo/Consequence.text = OptOneConsequence
	_turnPage();

func _on_option_2_btn_pressed():
	$PageTwo/Result.text = OptTwoResult
	$PageTwo/Consequence.text = OptTwoConsequence
	_turnPage();

func _on_option_3_btn_pressed():
	$PageTwo/Result.text = OptThreeResult
	$PageTwo/Consequence.text = OptThreeConsequence
	_turnPage();

func _on_leave_btn_pressed():
	SceneLoader.load_scene(exit_scene_path);
