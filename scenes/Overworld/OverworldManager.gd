class_name OverworldManager
extends Node

# Overworld Manager Singleton
# represents map progress as a whole,
# persists while Overworld scene is not active

var MapRoot:OverworldNode;
var CurrBattleDifficulty:int = 8;

var CurrSeason:int = SEASON_SPRING;
const SEASON_SPRING:int = 0;
const SEASON_SUMMER:int = 1;
const SEASON_AUTUMN:int = 2;
const SEASON_WINTER:int = 3;
var CurrSubseason:int = 0; # 0..359

# variables from the scene we hold onto when it is unloaded
var Camera_CurrentY = null;
var Clock_Rotate = null;

var pendingSeasonAdvancement = 0

var WeFightTheAnole = false
var WeShowedTheEndingScreen = false

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
	#print("OverworldManager:: mapPopulate");
	# call to begin a new game, before overworld scene loads
	WeFightTheAnole = false
	WeShowedTheEndingScreen = false
	# season progress
	CurrSeason = SEASON_SPRING;
	CurrSubseason = 22.5
	
	# map nodes populate (hard coded)
	
	var AA = OverworldNode.new(OverworldNode.MAPNODETYPE_BOOK);
	var AB = OverworldNode.new(OverworldNode.MAPNODETYPE_CAMP);
	var BA = OverworldNode.new(OverworldNode.MAPNODETYPE_FOE);
	var BB = OverworldNode.new(OverworldNode.MAPNODETYPE_BOOK);
	
	AA.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_FOE));
	AA.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_SHOP));
	AA.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_BOOK));
	AA.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_FOE));
	AA.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_CAMP));
	
	AB.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_BIGFOE));
	AB.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_BOOK));
	AB.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_FOE));
	AB.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_BOOK));
	AB.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_CAMP));
	
	BA.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_BOOK));
	BA.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_FOE));
	BA.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_SHOP));
	BA.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_FOE));
	BA.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_BOOK));
	BA.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_CAMP));
	
	BB.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_FOE));
	BB.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_SHOP));
	BB.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_FOE));
	BB.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_BOOK));
	BB.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_BIGFOE));
	BB.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_CAMP));
	
	var A = OverworldNode.new(OverworldNode.MAPNODETYPE_BOOK);
	var B = OverworldNode.new(OverworldNode.MAPNODETYPE_SHOP);
	
	A.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_FOE));
	A.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_FOE));
	A.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_BOOK));
	A.childNodes[0].childNodes[0].childNodes[0].addChild(AA);
	A.childNodes[0].childNodes[0].childNodes[0].addChild(AB);
	
	B.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_FOE));
	B.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_CAMP));
	B.childNodes[0].childNodes[0].addChild(BA);
	B.childNodes[0].childNodes[0].addChild(BB);
	
	MapRoot = OverworldNode.new(OverworldNode.MAPNODETYPE_EMPTY);
	MapRoot.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_FOE));
	MapRoot.childNodes[0].addChild(A);
	MapRoot.childNodes[0].addChild(B);

###########################################################
# only the overworld scene should be calling these:       #
###########################################################

func mapGetRoot():
	#print("OverworldManager:: mapGetRoot");
	return MapRoot;

func setBattleDifficulty(val:int):
	CurrBattleDifficulty = val;

func consumePendingSeasonChange():
	OverworldSingleton.advanceSeason(pendingSeasonAdvancement)
	pendingSeasonAdvancement = 0

func loadStuff(CurrentWorld):
	#print("OverworldManager:: loadStuff");
	# overworld scene is asking for data
	if(Camera_CurrentY != null):
		CurrentWorld.Camera_CurrentY = Camera_CurrentY;
	if(Clock_Rotate != null):
		CurrentWorld.Clock_Rotate = Clock_Rotate;

func saveStuff(CurrentWorld):
	#print("OverworldManager:: saveStuff");
	# overworld scene is being unloaded & giving data
	Camera_CurrentY = CurrentWorld.Camera_CurrentY;
	Clock_Rotate = CurrentWorld.Clock_Rotate;

# private methods

func _ready():
	#print("OverworldManager:: _ready");
	mapPopulate();
