class_name OverworldNode
extends Resource

# Overworld Map Node Class
# represents individual map node - not a scene,
# but data that persists while Overworld Scene is not active

const NODETYPE_DURATIONS:Array = [0, 45, 45, 45, 90, 90, 45]; # how many deg does clock advance?
const MAPNODETYPE_EMPTY:int = 0;
const MAPNODETYPE_FOE:int = 1;
const MAPNODETYPE_BIGFOE:int = 2;
const MAPNODETYPE_SHOP:int = 3;
const MAPNODETYPE_CAMP:int = 4;
const MAPNODETYPE_BOOK:int = 5;
const MAPNODETYPE_FINAL:int = 6;

# randomizing nodes
const NODETYPE_RANDOM_WEIGHT:Array = [0, 4, 1, 2, 2, 1, 0]; # how strongly will randomType() favor this node type?
const MAPNODETYPE_RANDOM:int = -1;

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
	#print("OverworldNode:: init type " + str(newNodeType));
	if(newNodeType == MAPNODETYPE_RANDOM): nodeType = OverworldNode.randomType();
	else: nodeType = newNodeType;

static func randomType():
	# return a weighted random type
	var sumOfWeights:int = 0;
	for thisWeight:int in NODETYPE_RANDOM_WEIGHT:
		sumOfWeights += thisWeight;
	var RNG:int = randi_range(1, sumOfWeights);
	
	for thisWeightIdx:int in range(NODETYPE_RANDOM_WEIGHT.size()):
		RNG -= NODETYPE_RANDOM_WEIGHT[thisWeightIdx];
		if(RNG <= 0): return thisWeightIdx;
	return MAPNODETYPE_EMPTY; # unreachable

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
	#print("OverworldNode:: launch type " + str(nodeType));
	_launched = true;
	var isLeavingScene:bool = false;
	
	match(nodeType):
		MAPNODETYPE_FOE:
			OverworldSingleton.setBattleDifficulty(findDepth());
			SceneLoader.load_scene("res://scenes/BattleBoard/BattleBoard.tscn");
			isLeavingScene = true;
		MAPNODETYPE_BIGFOE:
			OverworldSingleton.setBattleDifficulty(findDepth()+5);
			SceneLoader.load_scene("res://scenes/BattleBoard/BattleBoard.tscn");
			isLeavingScene = true;
		MAPNODETYPE_FINAL:
			OverworldSingleton.setBattleDifficulty(findDepth()+10);
			if OverworldSingleton.WeShowedTheEndingScreen:
				SceneLoader.load_scene("res://scenes/BattleBoard/BattleBoard.tscn");
			else:
				SceneLoader.load_scene("res://scenes/Anole/Anole.tscn");
			isLeavingScene = true;
		MAPNODETYPE_SHOP:
			SceneLoader.load_scene("res://scenes/Shop/Shop.tscn");
			isLeavingScene = true;
		MAPNODETYPE_BOOK:
			SceneLoader.load_scene("res://scenes/Rest/rest_book.tscn");
			isLeavingScene = true;
		MAPNODETYPE_CAMP:
			SceneLoader.load_scene("res://scenes/Rest/rest_book.tscn");
			isLeavingScene = true;
	
	# consume node / advance season
	#OverworldSingleton.advanceSeason(NODETYPE_DURATIONS[nodeType]);
	OverworldSingleton.pendingSeasonAdvancement = NODETYPE_DURATIONS[nodeType]
	nodeType = MAPNODETYPE_EMPTY;
	
	return isLeavingScene;

func findFurthestLaunched():
	# recursively finds the furthest-most launched map node.
	# assuming the player only goes forward, that is
	for thisChildIdx:int in range(childNodes.size()):
		if(childNodes[thisChildIdx].hasLaunched()):
			return childNodes[thisChildIdx].findFurthestLaunched();
	return self;

func findDepth():
	# recursively finds the depth of this node by reaching up towards map root
	var theRootNode:OverworldNode = OverworldSingleton.mapGetRoot();
	if(self == theRootNode): return 0;
	if(parentNode == theRootNode): return 1;
	return 1 + parentNode.findDepth();

func killLinks():
	# recursively removes all local links
	localSceneLink = null;
	for thisChildIdx:int in range(childNodes.size()):
		childNodes[thisChildIdx].killLinks();
