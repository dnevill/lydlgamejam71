extends Control

enum {REST, EAT, PURGE}
var SelectedOption = REST
signal optionRegistered

const REST_AMOUNT = 10

var disc_inventory_label = preload("res://scenes/BattleBoard/UI/disc_inventory_label.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visibility_changed():
	if visible:
		_on_show_page()

func _on_show_page():
	await optionRegistered
	if SelectedOption == REST:
		_rested_page()
	elif SelectedOption == EAT:
		_eating_page()
	else:
		_purged_page()


func _rested_page():
	$Result.text = "You rest and try to recover some health."
	PSM.heal(REST_AMOUNT, get_global_mouse_position())
	$Consequence.text = "You heal for " + str(REST_AMOUNT)
	pass

func _eating_page():
	var weAte = PSM.spend_flies(100, get_global_mouse_position())
	if weAte:
		$Result.text = "You consume some flies. Although your stomach settles, but your heart still yearns for revenge."
		$Consequence.text = "You gain 5 maximum health."
		PSM.change_max_health(5)
	else:
		$Result.text = "You don't have enough flies to make a proper meal of it. Your stomach rumbles, and you lumber on sluggishly."
		$Consequence.text = "Your maximum health improves slightly"
		PSM.change_max_health(1)

func _purged_page():
	$Result.text = "You discard a stone."
	$LeaveBtn.visible = false
	$Consequence.visible = false
	var discsYouCanChoose = PSM.returnRandomDiscs(3)
	_populate_purge_ui(discsYouCanChoose)


func _populate_purge_ui(discs):
	print(discs)
	for disc in discs:
		var this_label : DiscInventoryLabel = disc_inventory_label.instantiate()
		this_label.discobject = load(disc).instantiate()
		this_label.setTextColor($Result.label_settings.font_color)
		this_label.connect("discselected", _on_disc_selected)
		$DiscSelection/GridContainer.add_child(this_label)
		#print("Adding " + str(this_label))
	$DiscSelection.visible = true
	return true

func _on_disc_selected(disc : Disc, label_clicked : DiscInventoryLabel):
	PSM.removeDisc(disc)
	$DiscSelection.visible = false
	$LeaveBtn.visible = true
	$Consequence.text = "You remove a " +disc.get_disc_name() + " from your pouch"
	$Consequence.visible = true
	label_clicked.queue_free()

func _on_option_1_btn_pressed():
	SelectedOption = REST
	optionRegistered.emit()

func _on_option_2_btn_pressed():
	SelectedOption = EAT
	optionRegistered.emit()
	
func _on_option_3_btn_pressed():
	SelectedOption = PURGE
	optionRegistered.emit()
