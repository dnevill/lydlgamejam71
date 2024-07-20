class_name OverworldManager
extends Node

# Overworld Manager Singleton
# represents map progress as a whole,
# persists while Overworld scene is not active

var MapRoot:OverworldNode;
var CurrBattleDifficulty:int = 0;

var CurrSeason:int = SEASON_SPRING;
const SEASON_SPRING:int = 0;
const SEASON_SUMMER:int = 1;
const SEASON_AUTUMN:int = 2;
const SEASON_WINTER:int = 3;
var CurrSubseason:int = 0; # 0..359

# variables from the scene we hold onto when it is unloaded
var Camera_CurrentY = null;
var Clock_Rotate = null;

###########################################################
# fully public methods                                    #
###########################################################

func getSeason():
	# returns int 0..3
	var x:int = CurrSubseason + 45;
	if x >= 360: x -= 360;
	if x < 90: return SEASON_SPRING;
	elif x < 180: return SEASON_SUMMER;
	elif x < 270: return SEASON_AUTUMN;
	return SEASON_WINTER;
func getSubseason():
	# returns int 0..359
	return CurrSubseason;
func advanceSeason(ticks:int):
	# advances subseason by (ticks) degrees
	CurrSubseason += ticks;
	if(CurrSubseason >= 360): CurrSubseason -= 360;

func getBattleDifficulty():
	# returns int 1..15
	return CurrBattleDifficulty;

func mapPopulate():
	print("OverworldManager:: mapPopulate");
	# call to begin a new game, before overworld scene loads
	
	# season progress
	CurrSeason = SEASON_SPRING;
	CurrSubseason = 0;
	
	# map nodes populate (hard coded)
	MapRoot = OverworldNode.new(OverworldNode.MAPNODETYPE_EMPTY);
	MapRoot.addChild(OverworldNode.new(OverworldNode.MAPNODETYPE_EMPTY));
	MapRoot.addChild(OverworldNode.new(OverworldNode.MAPNODETYPE_FOE));
	
	MapRoot.childNodes[0].addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_SHOP));
	MapRoot.childNodes[0].addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_FOE));
	MapRoot.childNodes[0].addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_CAMP));
	MapRoot.childNodes[0].addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_BIGFOE));
	
	MapRoot.childNodes[1].addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_CAMP));
	MapRoot.childNodes[1].addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_FOE));
	MapRoot.childNodes[1].addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_BOOK));
	MapRoot.childNodes[1].addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_BIGFOE));

###########################################################
# only the overworld scene should be calling these:       #
###########################################################

func mapGetRoot():
	print("OverworldManager:: mapGetRoot");
	return MapRoot;

func setBattleDifficulty(val:int):
	CurrBattleDifficulty = val;

func loadStuff(CurrentWorld):
	print("OverworldManager:: loadStuff");
	# overworld scene is asking for data
	if(Camera_CurrentY != null):
		CurrentWorld.Camera_CurrentY = Camera_CurrentY;
	if(Clock_Rotate != null):
		CurrentWorld.Clock_Rotate = Clock_Rotate;

func saveStuff(CurrentWorld):
	print("OverworldManager:: saveStuff");
	# overworld scene is being unloaded & giving data
	Camera_CurrentY = CurrentWorld.Camera_CurrentY;
	Clock_Rotate = CurrentWorld.Clock_Rotate;

# private methods

func _ready():
	print("OverworldManager:: _ready");
	mapPopulate();
