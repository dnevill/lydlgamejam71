extends Node
##Player State Manager singlteon
##
## Manages the players health and flies (currency) as well as their deck
## This is a global singleton so be sure to reset the player between 'runs'
##
## Emits player_died signal if you kill the player
##
## Right now the deck is not private in any way and you access the Array (which is really a List) directly
class_name PlayerStateManager 


## Used to display changes in health or flies if a non-null [Vector2] is provided
var float_text = preload("res://scenes/BattleBoard/UI/floating_text.tscn")

##Player's health, if they run out due to damage they die
var Health : int : 
	get: return _health 

##Player's maximum health, they start with this much and can't have more than it
var MaxHealth : int : 
	get: return _maxHealth 

##Player's Flies, the currency used at shops
var Flies : int : 
	get: return _flies 

var PlayerDeckScenes = Array([], TYPE_STRING, &"", null) ##A list of Discs that makes up the player's deck, we might want to encapsulate this in a little helper class later

var _health : int
var _maxHealth : int
var _flies : int

var _basic_disc = "res://scenes/Discs/Player Disc Template/PlayerDiscTemplate.tscn"
var _ghost_disc = "res://scenes/Discs/Player - Ghost/ghost.tscn"
var _heavy_disc = "res://scenes/Discs/Player - Heavy/heavy_disc.tscn"
var _heal_disc = "res://scenes/Discs/Player - Healing/healing.tscn"

const STARTHEALTH = 100 ##Starting maximum health
const STARTFLIES = 25 ##Starting number of flies
const STARTDECKNO = 8 ##Starting number of basic discs in the player's deck

##Emitted when the player runs out of health after taking damage
signal player_died

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_player()


##Resets the player to the default starting Health, Flies and Deck contents.
func reset_player():
	_health = STARTHEALTH
	_maxHealth = STARTHEALTH
	_flies = STARTFLIES
	for n in range(STARTDECKNO):
		var disc_to_inst = _basic_disc
		if (n > 5):
			disc_to_inst = _heal_disc
		elif (n > 3):
			disc_to_inst = _heavy_disc
		elif (n > 1):
			disc_to_inst = _ghost_disc
		PlayerDeckScenes.append(disc_to_inst)

func giveBasicDisc():
	PlayerDeckScenes.append(_basic_disc);
func giveHeavyDisc():
	PlayerDeckScenes.append(_heavy_disc);

##Damages the player, does not overdamage below 0 HP. Emits [signal PlayerStateManager.player_died] if the player took enough damage to die
func damage(damageAmt : int, position : Vector2):
	_health = max(0, _health - damageAmt)
	if position != null and damageAmt != 0:
		var txtbox : FloatText = float_text.instantiate()
		txtbox.damage(damageAmt)
		txtbox.position = position
		get_tree().root.add_child(txtbox)
	if _health <= 0:
		player_died.emit()

##Tries to heal the player, will not overheal beyond [member PlayerStateManager.MaxHealth]
func heal(hitpoints : int, position : Vector2):
	_health = min(_maxHealth, _health + hitpoints)
	if position != null and hitpoints != 0:
		var txtbox : FloatText = float_text.instantiate()
		txtbox.heal(hitpoints)
		txtbox.position = position
		get_tree().root.add_child(txtbox)

##Adds some Flies to the players total
func add_flies(new_flies : int, position : Vector2):
	_flies += new_flies
	if position != null and new_flies != 0:
		var txtbox : FloatText = float_text.instantiate()
		txtbox.flies(new_flies)
		txtbox.position = position
		get_tree().root.add_child(txtbox)

##Tries to spend some Flies, like at a shop or event. Returns false and doesn't change flies if the player doesn't have enough flies
func spend_flies(price : int , position : Vector2) -> bool:
	if price <= _flies:
		_flies -= price
		if position != null and price != 0:
			var txtbox : FloatText = float_text.instantiate()
			txtbox.flies(-price)
			txtbox.position = position
			get_tree().root.add_child(txtbox)
		return true
	else: return false

##Provides the means to change the players maximum health (negative values to subtract), emits [signal PlayerStateManager.player_died] if this kills the player
##Doesn't reduce max health below 0
func change_max_health(health_change : int):
	_maxHealth = max(0, _maxHealth + health_change)
	_health = min(_health, _maxHealth)
	if MaxHealth <= 0:
		player_died.emit()
	
