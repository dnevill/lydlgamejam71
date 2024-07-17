extends Node2D
class_name BattleSM

#temp for now just to spawn in stuff for the proof of concept, later on these will get passed in via the enemies array probably
var disc_template = preload("res://scenes/Discs/Player Disc Template/PlayerDiscTemplate.tscn")
var enemy_template = preload("res://scenes/Discs/Enemy Disc Template/enemy_disc_template.tscn")
var enemies = Array([], TYPE_OBJECT, &"Node", EnemyDisc)
var placed_enemies = Array([], TYPE_OBJECT, &"Node", EnemyDisc)
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

var disc_in_hole : Disc = null

# Called when the node enters the scene tree for the first time.
func _ready():
	#This for loop is just, for now, populating some temporary targets
	for n in range(8):
		var this_enemy : EnemyDisc = enemy_template.instantiate()
		this_enemy.connect("went_in_hole", _on_hole_clear)
		#this_enemy.get_node("Sprite2D").modulate = Color(0.2,0.2,0.9)
		enemies.append(this_enemy)
	#print(PSM.PlayerDeckScenes)
	for scenepath : String in PSM.PlayerDeckScenes:
		var this_player = load(scenepath).instantiate()
		this_player.connect("went_in_hole", _on_hole_clear)
		playerdeck.append(this_player)
	#Later on we probably want to batch these up or something and randomize to get more interesting placement
	#We might just have specs provided on how/where to spawn
	place_enemies(100, 3, 0)
	place_enemies(300, 5, 0)
	populate_inventory_ui()
	state = States.START
	play_opening_anim()

func add_player_disc(disc_template):
		var this_player : Disc = disc_template.instantiate()
		#this_player.get_node("Sprite2D").modulate = Color(randf() * 0.2, 0.5, randf() * 0.5 + 0.5)
		this_player.connect("went_in_hole", _on_hole_clear)
		playerdeck.append(this_player)

func _process(_delta):
	$"../PScore".text = "F: " + str(PSM.Flies)
	$"../EScore".text = "HP: " + str(PSM.Health) + "/" + str(PSM.MaxHealth)



func play_opening_anim():
	#do some stuff here to animate the introduction to the battle
	#maybe place enemy discs and such here? Or place them in _ready before this
	$"../Camera2D".zoom = Vector2(0.1, 0.1)
	var tween = get_tree().create_tween()
	tween.tween_property($"../Camera2D", "zoom", Vector2(0.6,0.6),1)
	tween.parallel().tween_property($"../Camera2D", "rotation", TAU,1)
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
		placed_enemies.append(en_to_place)

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
	await clean_up_rim()
	$"../DiscSelection".visible = true
	state = States.CHOOSEDISC

func _on_ready_to_shoot():
	state = States.SHOOTDISC

func _on_ready_for_physics():
	state = States.SHOTPHYSICSRUNNING

func _on_ready_for_enemy():
	state = States.ENEMYTURN
	await clean_up_rim()
	Engine.time_scale = 1.0
	#print("Engine is now going at " + str(Engine.time_scale) + "x")
	#print("enemy turn")
	var last_enemy : EnemyDisc = null
	for enemy : EnemyDisc in placed_enemies:
		if not enemy.guttered:
			#print("Taking the turn of " + str(enemy))
			enemy.take_turn()
			last_enemy = enemy
			#await enemy.turn_finished
			#print("Done with the turn of " + str(enemy))
	await last_enemy.turn_finished
	#Do some stuff for the enemy turn here
	Engine.time_scale = 1.0
	#print("Engine is now going at " + str(Engine.time_scale) + "x")
	if playerdeck.is_empty():
		ready_to_end.emit()
	else:
		ready_to_choose.emit()

func score_area(scoring_area : Area2D, score : int):
	for body in scoring_area.get_overlapping_bodies():
		if body is Disc:
			body.score(score)
			await get_tree().create_timer(0.5).timeout
	return true

func clean_up_rim():
	await clean_hole()
	for body in $"../SpriteEdge/Area2D".get_overlapping_bodies():
		if body is Disc:
			body.apply_central_impulse(body.position * 0.75) #HACK Depends on the hole being at 0,0 to use this simplification
			await get_tree().create_timer(0.5).timeout
	return true

#TODO this should really call the discs own score function for 20, and then I need to also make sure the disc isn't queueing free itself early
func _on_hole_clear(cleared_disc):
	disc_in_hole = cleared_disc
	disc_in_hole.toggle_collision()
	$"../Sprite20PT".toggle_collision()


## Scores and clears whatever is in the hole, this is typically called after the player's physics finishes and after the enemy physics finishes
## Keeping this like classic crokinole rules ensures the enemy can't get several lucky 20s without the player getting to act!
func clean_hole():
	print("cleaning hole")
	if disc_in_hole != null:
		if disc_in_hole is EnemyDisc:
			placed_enemies.remove_at(placed_enemies.find(disc_in_hole))
		$"../Sprite20PT".toggle_collision()
		disc_in_hole.score(20)
		disc_in_hole = null
		print("starting timer")
		await get_tree().create_timer(1).timeout
		print("timer done")
		return true
	else:
		return false

func _on_ready_to_end():
	state = States.ENDCOMBAT
	#score remaining discs
	await score_area($"../Sprite15PT/Area2D", 15)
	await score_area($"../Sprite10PT/Area2D", 10)
	await score_area($"../Sprite5PT/Area2D", 5)
	print("Player now has " + str(PSM.Health) + " of " + str(PSM.MaxHealth) + " health and " + str(PSM.Flies) + " flies")

