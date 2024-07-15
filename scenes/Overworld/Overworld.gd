extends Control

const MapNodeSIZE = 64;
const MapNodePADDING = 32;

@onready var CameraObj = $CameraObj;
@onready var MapNodes = $WorldNode/MapNodes;
@onready var BGArt = $WorldNode/BGLayer/BGArtwork;
@onready var MidpointX = size.x / 2;
@onready var MapOriginX = BGArt.texture.get_width() / 2;
@onready var MapOriginY = BGArt.texture.get_height() - 100;
@onready var MapNodeSCENE = preload("res://scenes/Overworld/MapNode.tscn");

# variables which are loaded to / recalled from the singleton
var Camera_CurrentY = null;

func _enter_tree():
	OverworldSingleton.loadStuff(self);

func drawMapNodes(drawingNode:OverworldNode, drawLocX:float, drawLocY:float):
	print("Overworld:: drawMapNodes type" + str(drawingNode.nodeType) + " @ " + str(drawLocX) + ", " + str(drawLocY));
	
	# draw the Overworld map node
	if(drawingNode == OverworldSingleton.mapGetRoot()):
		pass; # do not actually draw root node
	else:
		var newMapNode = MapNodeSCENE.instantiate();
		newMapNode.get_child(0).set_frame(drawingNode.nodeType);
		newMapNode.position = Vector2(drawLocX, drawLocY);
		MapNodes.add_child(newMapNode);
	
	var numberOfChildren = drawingNode.childNodes.size();
	if(numberOfChildren == 1):
		
		# just draw this 1 child straight up
		drawMapNodes(drawingNode.childNodes[0], drawLocX, drawLocY - MapNodeSIZE - MapNodePADDING);
		
	elif(numberOfChildren > 1):
		
		# determine how much x-space is needed by each child
		var neededWidths:Array = Array();
		var neededWidthTotal:float = 0;
		for thisChildIdx:int in range(numberOfChildren):
			var thisChild:OverworldNode = drawingNode.childNodes[thisChildIdx];
			var thisNWidth:int = (MapNodeSIZE * thisChild.widestBranch) + (MapNodePADDING * (thisChild.widestBranch-1));
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
			
			drawMapNodes(thisChild, thisDrawX, drawLocY - MapNodeSIZE - MapNodePADDING);
			consumedNeededWidth += neededWidths[thisChildIdx] + MapNodePADDING;

func _ready():
	# line up camera with center of map artwork
	CameraObj.position.x = -(size.x - BGArt.texture.get_width())/2;
	
	# if there was a stored camera Y, return there
	if(Camera_CurrentY != null):
		CameraObj.position.y = Camera_CurrentY;
	
	drawMapNodes(OverworldSingleton.mapGetRoot(), MapOriginX, MapOriginY);

func _process(_delta):
	# scroll camera down, stop at bottom of map artwork
	if(CameraObj.position.y < BGArt.texture.get_height() - size.y):
		CameraObj.position.y += 4;
		Camera_CurrentY = CameraObj.position.y;

func _exit_tree():
	OverworldSingleton.saveStuff(self);
