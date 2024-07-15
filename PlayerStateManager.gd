extends Node
class_name PlayerStateManager ##Player State Manager singlteon

var Health : int ##Player's health, if they run out due to damage they die
var MaxHealth : int ##Player's maximum health, they start with this much and can't have more than it
var Flies : int ##Player's Flies, the currency used at shops
var PlayerDeck = Array([], TYPE_OBJECT, &"Node", Disc) ##A list of Discs that makes up the player's deck, we might want to encapsulate this in a little helper class later

var basic_disc = preload("res://scenes/Discs/Player Disc Template/PlayerDiscTemplate.tscn")


const STARTHEALTH = 100 ##Starting maximum health
const STARTFLIES = 25 ##Starting number of flies
const STARTDECKNO = 4 ##Starting number of basic discs in the player's deck

##Emitted when the player runs out of health after taking damage
signal player_died

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_player()


##Resets the player to the default starting Health, Flies and Deck contents.
func reset_player():
	Health = STARTHEALTH
	MaxHealth = STARTHEALTH
	Flies = STARTFLIES
	for n in range(STARTDECKNO):
		var this_playerd = basic_disc.instantiate()
		PlayerDeck.append(this_playerd)

##Damages the player, does not overdamage below 0 HP. Emits [self.player_died] if the player took enough damage to die
func damage(damage : int):
	Health = max(0, Health - damage)
	if Health <= 0:
		player_died.emit()

##Tries to heal the player, will not overheal beyond [self.MaxHealth]
func heal(hitpoints : int):
	Health = min(MaxHealth, Health + hitpoints)

##Adds some Flies to the players total
func add_flies(new_flies : int):
	Flies += new_flies

##Tries to spend some Flies, like at a shop or event. Returns false and doesn't change flies if the player doesn't have enough flies
func spend_flies(price : int ) -> bool:
	if price <= Flies:
		Flies -= price
		return true
	else: return false

##Provides the means to change the players maximum health (negative values to subtract), emits [self.player_died] if this kills the player
##Doesn't reduce max health below 0
func change_max_health(health_change : int):
	MaxHealth = max(0, MaxHealth + health_change)
	if MaxHealth <= 0:
		player_died.emit()
	
