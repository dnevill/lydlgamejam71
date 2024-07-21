class_name OverworldNode
extends Resource

# Overworld Map Node Class
# represents individual map node - not a scene,
# but data that persists while Overworld Scene is not active

const NODETYPE_DURATIONS:Array = [0, 30, 45, 15, 15, 30]; # how many deg does clock advance?
const MAPNODETYPE_EMPTY:int = 0;
const MAPNODETYPE_FOE:int = 1;
const MAPNODETYPE_BIGFOE:int = 2;
const MAPNODETYPE_SHOP:int = 3;
const MAPNODETYPE_CAMP:int = 4;
const MAPNODETYPE_BOOK:int = 5;

var _launched:bool = false;
var parentNode:OverworldNode = null;
var childNodes:Array = Array();
var _widestBranch:int = 1;
var nodeType:int;

# must clear this when scene exits
var localSceneLink:Node2D = null;

func _init(newNodeType:int):
	# constructor
	# newNodeType determines how it's drawn.  Will eventually pass in more info
	print("OverworldNode:: init type " + str(newNodeType));
	nodeType = newNodeType;

func getWidest():
	return _widestBranch;

func _updateWidest(newSize:int):
	# keep track of how many nodes, at widest, this tree has
	# this is necessary to know much space to give each branch
	if(newSize > _widestBranch):
		_widestBranch = newSize;
		if(parentNode != null):
			parentNode._updateWidest(newSize);

func addChild(newNode:OverworldNode):
	# add a child node to this node
	childNodes.push_back(newNode);
	newNode.parentNode = self;
	
	# it is possible that this is now the widest point in the tree
	_updateWidest(max(childNodes.size(),newNode._widestBranch));

func addToChain(newNode:OverworldNode):
	# forms a chain (no-branch tree) if called repeatedly.
	if(childNodes.size() > 0):
		childNodes[0].addToChain(newNode);
	else:
		self.addChild(newNode);

func hasLaunched():
	return _launched;

func launch():
	# launch the activity that this overworld Node represents
	# returns false if did not result in launching new scene
	print("OverworldNode:: launch type " + str(nodeType));
	_launched = true;
	var isLeavingScene:bool = false;
	
	match(nodeType):
		MAPNODETYPE_FOE:
			OverworldSingleton.setBattleDifficulty(8);
			SceneLoader.load_scene("res://scenes/BattleBoard/BattleBoard.tscn");
			isLeavingScene = true;
		MAPNODETYPE_BIGFOE:
			OverworldSingleton.setBattleDifficulty(16);
			SceneLoader.load_scene("res://scenes/BattleBoard/BattleBoard.tscn");
			isLeavingScene = true;
		MAPNODETYPE_SHOP:
			SceneLoader.load_scene("res://scenes/Shop/Shop.tscn");
			isLeavingScene = true;
	
	# consume node / advance season
	OverworldSingleton.advanceSeason(NODETYPE_DURATIONS[nodeType]);
	nodeType = MAPNODETYPE_EMPTY;
	
	return isLeavingScene;

func findFurthestLaunched():
	# recursively finds the furthest-most launched map node.
	# assuming the player only goes forward, that is
	for thisChildIdx:int in range(childNodes.size()):
		if(childNodes[thisChildIdx].hasLaunched()):
			return childNodes[thisChildIdx].findFurthestLaunched();
	return self;

func killLinks():
	# recursively removes all local links
	localSceneLink = null;
	for thisChildIdx:int in range(childNodes.size()):
		childNodes[thisChildIdx].killLinks();
