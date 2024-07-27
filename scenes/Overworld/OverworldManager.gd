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
	
	# map nodes populate
	
	var AA = OverworldMapGenerator.createChain(6);
	var AB = OverworldMapGenerator.createChain(6);
	var BA = OverworldMapGenerator.createChain(7);
	var BB = OverworldMapGenerator.createChain(7);
	
	var A = OverworldMapGenerator.createChain(4);
	var B = OverworldMapGenerator.createChain(3);
	
	var A_FINAL = OverworldMapGenerator.findFinalNode(A);
	A_FINAL.addChild(AA);
	A_FINAL.addChild(AB);
	
	var B_FINAL = OverworldMapGenerator.findFinalNode(B);
	B_FINAL.addChild(BA);
	B_FINAL.addChild(BB);
	
	MapRoot = OverworldNode.new(OverworldNode.MAPNODETYPE_EMPTY);
	var initialFoe:OverworldNode = OverworldNode.new(OverworldNode.MAPNODETYPE_FOE);
	MapRoot.addToChain(initialFoe);
	
	initialFoe.addChild(A);
	initialFoe.addChild(B);
	
	OverworldMapGenerator.scrubTree(MapRoot, OverworldNode.MAPNODETYPE_EMPTY);

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
