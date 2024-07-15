extends Node2D
class_name BattleSM

#temp for now just to spawn in stuff for the proof of concept, later on these will get passed in via the enemies array probably
var disc_template = preload("res://scenes/Discs/Player Disc Template/PlayerDiscTemplate.tscn")
var enemies = Array([], TYPE_OBJECT, &"Node", Disc)
var playerdeck = Array([], TYPE_OBJECT, &"Node", Disc)

var disc_inventory_label = preload("res://scenes/BattleBoard/UI/disc_inventory_label.tscn")

#Tracking the game state
enum States {START, CHOOSEDISC, PLACEDISC, SHOOTDISC, SHOTPHYSICSRUNNING, ENEMYTURN, ENDCOMBAT}
signal ready_to_choose
signal ready_to_place
signal ready_to_shoot
signal ready_for_physics
signal ready_for_enemy
signal ready_to_end
var state

# Called when the node enters the scene tree for the first time.
func _ready():
	#This for loop is just, for now, populating some temporary targets
	for n in range(8):
		var this_enemy = disc_template.instantiate()
		this_enemy.get_node("Sprite2D").modulate = Color(0.2,0.2,0.9)
		enemies.append(this_enemy)
		var this_player = disc_template.instantiate()
		this_player.get_node("Sprite2D").modulate = Color(randf(), randf(), 0)
		playerdeck.append(this_player)
	#Later on we probably want to batch these up or something and randomize to get more interesting placement
	#We might just have specs provided on how/where to spawn
	place_enemies(100, 3, 0)
	place_enemies(300, 5, 0)
	populate_inventory_ui()
	state = States.START
	play_opening_anim()

func play_opening_anim():
	#do some stuff here to animate the introduction to the battle
	#maybe place enemy discs and such here? Or place them in _ready before this
	$"../Camera2D".zoom = Vector2(0.1, 0.1)
	var tween = get_tree().create_tween()
	tween.tween_property($"../Camera2D", "zoom", Vector2(0.6,0.6),2)
	tween.parallel().tween_property($"../Camera2D", "rotation", TAU,2)
	tween.tween_callback(done_opening)

func done_opening():
	emit_signal("ready_to_choose")

#Places a certain number of enemies from the class wide enemies pool at a specified radius in a symmetrical fashion
func place_enemies(radius, num_to_place, step_factor_offset):
	var step_size = TAU / num_to_place
	for angle in Vector3(0.0, TAU, step_size):
		var en_to_place = enemies.pop_front()
		en_to_place.position = Vector2.UP.rotated(angle + step_size * step_factor_offset) * radius
		add_child(en_to_place)

func populate_inventory_ui():
	for disc in playerdeck:
		var this_label : DiscInventoryLabel = disc_inventory_label.instantiate()
		this_label.discobject = disc
		this_label.connect("discselected", _on_disc_selected)
		$"../DiscSelection/GridContainer".add_child(this_label)

func _on_disc_selected(disc : Disc, label_clicked):
	if state == States.CHOOSEDISC:
		label_clicked.queue_free()
		$"..".ready_disc(disc)
		playerdeck.remove_at(playerdeck.find(disc))
		print("We pulled " + str(disc) + "Out of the remaining deck" + str(playerdeck))
		$"../DiscSelection".visible = false
		state = States.PLACEDISC

func _on_ready_to_choose():
	$"../DiscSelection".visible = true
	state = States.CHOOSEDISC


func _on_ready_to_shoot():
	state = States.SHOOTDISC


func _on_ready_for_physics():
	state = States.SHOTPHYSICSRUNNING


func _on_ready_for_enemy():
	state = States.ENEMYTURN
	#Do some stuff for the enemy turn here
	if playerdeck.is_empty():
		ready_to_end.emit()
	else:
		ready_to_choose.emit()


func _on_ready_to_end():
	state = States.ENDCOMBAT
