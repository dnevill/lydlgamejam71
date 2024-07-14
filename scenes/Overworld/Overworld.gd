extends Control

const MapNodeSIZE = 128;
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
	
	# spawn a map node
	var newMapNode = MapNodeSCENE.instantiate();
	newMapNode.position = Vector2(drawLocX, drawLocY);
	MapNodes.add_child(newMapNode);
	
	if(drawingNode.childNodes.size() == 1):
		# one child
		drawMapNodes(drawingNode.childNodes[0], drawLocX, drawLocY - MapNodeSIZE - MapNodePADDING);
	elif(drawingNode.childNodes.size() > 1):
		# multiple children
		var neededWidths:Array = Array();
		var neededWidthTotal:float = 0;
		for thisChild:OverworldNode in drawingNode.childNodes:
			var thisNWidth:int = (MapNodeSIZE * thisChild.widestBranch) + (MapNodePADDING * (thisChild.widestBranch-1));
			neededWidths.push_front(thisNWidth);
			neededWidthTotal += thisNWidth;
			print("neededWidth = " + str(thisNWidth));
		neededWidthTotal += (MapNodePADDING * (drawingNode.childNodes.size()-1));
		print("neededWidthTotal = " + str(neededWidthTotal));
		
		var consumedNeededWidth:int = 0;
		var thisChildIdx:int = 0;
		drawingNode.childNodes.reverse(); # not sure why but the second for loop was going through in reverse order
		for thisChild:OverworldNode in drawingNode.childNodes:
			var thisDrawX:float = drawLocX;
			thisDrawX -= (neededWidthTotal/2); # leftmost edge
			thisDrawX += consumedNeededWidth; # move past already consumed area
			thisDrawX += neededWidths[thisChildIdx]/2; # move halfway past the needed width (since we're placing the center)
			print("neededWidths[" + str(thisChildIdx) + "] = " + str(neededWidths[thisChildIdx]));
			
			drawMapNodes(thisChild, thisDrawX, drawLocY - MapNodeSIZE - MapNodePADDING);
			
			consumedNeededWidth += neededWidths[thisChildIdx] + MapNodePADDING;
			thisChildIdx += 1;

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
