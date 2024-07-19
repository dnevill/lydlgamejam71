class_name OverworldManager
extends Node

# Overworld Manager Singleton
# represents map progress as a whole,
# persists while Overworld scene is not active

var MapRoot:OverworldNode;

var CurrSeason:int = SEASON_SPRING;
const SEASON_SPRING:int = 0;
const SEASON_SUMMER:int = 1;
const SEASON_AUTUMN:int = 2;
const SEASON_WINTER:int = 3;
var CurrSubseason:int = 0; # new season starts at 360.

# variables from the scene we hold onto when it is unloaded
var Camera_CurrentY = null;
var Clock_Rotate = null;

###########################################################
# fully public methods                                    #
###########################################################

func getSeason():
	# returns int 0..3
	return CurrSeason;
func getSubseason():
	# returns int 0..359
	return CurrSubseason;
func advanceSeason(ticks:int):
	# advances subseason by (ticks) degrees
	CurrSubseason += ticks;
	if(CurrSubseason > 359):
		# new season
		CurrSubseason -= 360;
		CurrSeason += 1;
		if(CurrSeason > SEASON_WINTER): CurrSeason = SEASON_SPRING;

func mapPopulate():
	print("OverworldManager:: mapPopulate");
	# call to begin a new game, before overworld scene loads
	
	# season progress
	CurrSeason = SEASON_SPRING;
	CurrSubseason = 0;
	
	# map nodes populate
	MapRoot = OverworldNode.new(OverworldNode.MAPNODETYPE_EMPTY);
	MapRoot.addChild(OverworldNode.new(OverworldNode.MAPNODETYPE_FOE));
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
