extends Control

# code for Overworld Map Scene
# has to load from / save to OW Singleton when loading / unloading
# acts as a *representation only* of the Overworld Map data -
# all changes have to go through the Singleton

const MapNodeSIZE = 64;
const MapNodePADDING = 50;

@onready var CameraObj = $CameraObj;
@onready var MapNodes = $WorldNode/MapNodes;
@onready var BGArt = $WorldNode/BGLayer/BGArtwork;
@onready var MidpointX = size.x / 2;
@onready var MapOriginX = BGArt.texture.get_width() / 2;
@onready var MapOriginY = BGArt.texture.get_height() - MapNodePADDING;
@onready var MapNodeSCENE = preload("res://scenes/Overworld/MapNode.tscn");

# variables which are loaded to / recalled from the singleton
var Camera_CurrentY = null;

# variables that can be managed by the scene
var PlayerCurrNode:OverworldNode = null;

func _enter_tree():
	OverworldSingleton.loadStuff(self);

func _drawMapNodes(drawingNode:OverworldNode, drawLocX:float, drawLocY:float):
	print("Overworld:: _drawMapNodes type" + str(drawingNode.nodeType) + " @ " + str(drawLocX) + ", " + str(drawLocY));
	
	# draw the Overworld map node
	var newMapNode = MapNodeSCENE.instantiate();
	newMapNode.get_child(1).set_frame(drawingNode.nodeType); # main sprite
	newMapNode.get_child(0).set_frame(randi()%2); # lilypad
	newMapNode.get_child(0).play();
	newMapNode.position = Vector2(drawLocX, drawLocY);
	MapNodes.add_child(newMapNode);
	
	# link back to structure
	drawingNode.localSceneLink = newMapNode;
	
	var numberOfChildren = drawingNode.childNodes.size();
	if(numberOfChildren == 1):
		
		# just draw this 1 child straight up
		_drawMapNodes(drawingNode.childNodes[0], drawLocX, drawLocY - MapNodeSIZE - MapNodePADDING);
		
	elif(numberOfChildren > 1):
		
		# determine how much x-space is needed by each child
		var neededWidths:Array = Array();
		var neededWidthTotal:float = 0;
		for thisChildIdx:int in range(numberOfChildren):
			var thisChild:OverworldNode = drawingNode.childNodes[thisChildIdx];
			var thisNWidth:int = (MapNodeSIZE * thisChild.getWidest()) + (MapNodePADDING * (thisChild.getWidest()-1));
			neededWidths.push_back(thisNWidth);
			neededWidthTotal += thisNWidth;
		neededWidthTotal += (MapNodePADDING * (drawingNode.childNodes.size()-1));
		
		var consumedNeededWidth:int = 0;
		for thisChildIdx:int in range(numberOfChildren):
			var thisChild:OverworldNode = drawingNode.childNodes[thisChildIdx];
			var thisDrawX:float = drawLocX;
			thisDrawX -= (neededWidthTotal/2); # leftmost edge
			thisDrawX += consumedNeededWidth; # move past already consumed area
			thisDrawX += neededWidths[thisChildIdx]/2; # move halfway past the needed width (since we're placing the center)
			
			_drawMapNodes(thisChild, thisDrawX, drawLocY - MapNodeSIZE - MapNodePADDING);
			consumedNeededWidth += neededWidths[thisChildIdx] + MapNodePADDING;

func _findPlayerCurrNode():
	PlayerCurrNode = OverworldSingleton.mapGetRoot().findFurthestLaunched();
	# spawn player icon on top of this node
	pass;

func _activateNextNodes():
	# do something to all nodes accessible from PlayerCurrNode
	for thisChildIdx:int in range(PlayerCurrNode.childNodes.size()):
		var thisChildNode:OverworldNode = PlayerCurrNode.childNodes[thisChildIdx];
		thisChildNode.localSceneLink.get_child(0).set("modulate",Color("00ff00"));

func _ready():
	# line up camera with center of map artwork
	CameraObj.position.x = -(size.x - BGArt.texture.get_width())/2;
	
	# if there was a stored camera Y, return there
	if(Camera_CurrentY != null):
		CameraObj.position.y = Camera_CurrentY;
	
	_drawMapNodes(OverworldSingleton.mapGetRoot(), MapOriginX, MapOriginY);
	_findPlayerCurrNode();
	_activateNextNodes();

func _process(_delta):
	# scroll camera down, stop at bottom of map artwork
	if(CameraObj.position.y < BGArt.texture.get_height() - size.y):
		CameraObj.position.y += 4;
		Camera_CurrentY = CameraObj.position.y;

func _exit_tree():
	OverworldSingleton.saveStuff(self);
	OverworldSingleton.mapGetRoot().killLinks();
