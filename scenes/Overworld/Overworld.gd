extends Control

# code for Overworld Map Scene
# has to load from / save to OW Singleton when loading / unloading
# acts as a *representation only* of the Overworld Map data -
# all changes have to go through the Singleton

const MapNodeSIZE = 64;
const MapNodePADDING = 50; # pixels between Map Nodes
const MapOriginPADDING = 150; # pixels from bottom Map begins
const CAMERA_SPEED = 4; # pixels per frame

const MAPNODECHILD_LILYPAD = 0;
const MAPNODECHILD_HALO = 1;
const MAPNODECHILD_ICON = 2;
const MAPNODECHILD_BTN = 3;

@onready var CameraObj = $CameraObj;
@onready var MapNodes = $WorldNode/MapNodes;
@onready var BGArt = $WorldNode/BGLayer/BGArtwork;
@onready var BGArtWidth = BGArt.texture.get_width();
@onready var BGArtHeight = BGArt.texture.get_height();
@onready var PlayerIcon = $WorldNode/PlayerIcon;
@onready var SeasonClock = $CameraObj/Clock;
@onready var MidpointX = size.x / 2;
@onready var MapOriginX = (BGArtWidth * BGArt.scale.x) / 2;
@onready var MapOriginY = (BGArtHeight * BGArt.scale.y) - MapOriginPADDING;
@onready var MapNodeSCENE = preload("res://scenes/Overworld/MapNode.tscn");

# variables which are loaded to / recalled from the singleton
var Camera_CurrentY = null;
var Clock_Rotate = null;

# variables that can be managed by the scene
var PlayerCurrNode:OverworldNode = null;
var verticalMapProgress:int = 0;
@onready var desiredCameraY:float = (BGArtHeight * BGArt.scale.y) - size.y - verticalMapProgress;
var desiredClockRot:int = 0;
var listeningForBtns:bool = false;
var whichBtnHovered:int = -1;

func _enter_tree():
	OverworldSingleton.loadStuff(self);

func _drawMapNodes(drawingNode:OverworldNode, drawLocX:float, drawLocY:float):
	print("Overworld:: _drawMapNodes type" + str(drawingNode.nodeType) + " @ " + str(drawLocX) + ", " + str(drawLocY));
	
	###########################
	## CREATE THIS MAP NODE  ##
	###########################
	
	# draw the Overworld map node
	var newMapNode = MapNodeSCENE.instantiate();
	newMapNode.get_child(MAPNODECHILD_ICON).set_frame(drawingNode.nodeType);
	newMapNode.get_child(MAPNODECHILD_ICON).get_child(0).play("nodeicon_bounce");
	newMapNode.get_child(MAPNODECHILD_HALO).visible = false;
	newMapNode.get_child(MAPNODECHILD_LILYPAD).set_frame(randi() % 4);
	newMapNode.position = Vector2(drawLocX, drawLocY);
	MapNodes.add_child(newMapNode);
	
	# link Node2D back to structure
	drawingNode.localSceneLink = newMapNode;
	
	###########################
	## RECURSIVELY DRAW KIDS ##
	###########################
	
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
	PlayerIcon.position = PlayerCurrNode.localSceneLink.position;
	print("Overworld:: _findPlayerCurrNode setting icon position " + str(PlayerIcon.position.x) + ", " + str(PlayerIcon.position.y));
	PlayerIcon.get_child(0).play("playericon_bounce");
	PlayerIcon.visible = true;

func _activateNextNodes():
	# do something to all nodes accessible from PlayerCurrNode
	for thisChildIdx:int in range(PlayerCurrNode.childNodes.size()):
		var thisChildNode:OverworldNode = PlayerCurrNode.childNodes[thisChildIdx];
		thisChildNode.localSceneLink.get_child(MAPNODECHILD_HALO).get_child(1).play("halo_rotate");
		thisChildNode.localSceneLink.get_child(MAPNODECHILD_HALO).visible = true;
		thisChildNode.localSceneLink.get_child(MAPNODECHILD_BTN).visible = true;

func _cameraIsAtDesiredLoc():
	# enable inputs, etc.
	_activateNextNodes();
	listeningForBtns = true;

func _ready():
	# line up camera with center of map artwork
	CameraObj.position.x = -(size.x - (BGArtWidth * BGArt.scale.x))/2;
	
	# if there was a stored camera Y, return there
	if(Camera_CurrentY != null):
		CameraObj.position.y = Camera_CurrentY;
	
	# if there was a stored clock rotation, update
	if(Clock_Rotate != null):
		SeasonClock.rotation_degrees = Clock_Rotate;
	
	_drawMapNodes(OverworldSingleton.mapGetRoot(), MapOriginX, MapOriginY);
	_findPlayerCurrNode();
	_updateVerticalMapProgress();
	
	if(Camera_CurrentY == desiredCameraY):
		_cameraIsAtDesiredLoc();

func _updateVerticalMapProgress():
	verticalMapProgress = OverworldSingleton.mapGetRoot().localSceneLink.position.y - OverworldSingleton.mapGetRoot().findFurthestLaunched().localSceneLink.position.y;
	desiredCameraY = (BGArtHeight * BGArt.scale.y) - size.y - verticalMapProgress;
	desiredClockRot = OverworldSingleton.getSubseason();

func _adjustCamera():
	if(abs(int(CameraObj.position.y) - desiredCameraY) > CAMERA_SPEED):
		# further than CAMERA_SPEED away
		if(CameraObj.position.y < desiredCameraY):
			# camera must go down
			CameraObj.position.y += CAMERA_SPEED;
		else:
			# camera must go up
			CameraObj.position.y -= CAMERA_SPEED;
	elif(abs(int(CameraObj.position.y) - desiredCameraY) > 1):
		# very close
		if(CameraObj.position.y < desiredCameraY):
			# camera must go down
			CameraObj.position.y += 1;
		else:
			# camera must go up
			CameraObj.position.y -= 1;
	else:
		# camera is at desired location.
		if(Camera_CurrentY != CameraObj.position.y):
			print("Overworld:: _adjustCamera just arrived at "+str(CameraObj.position.y));
			
			# update camera location for singleton
			Camera_CurrentY = CameraObj.position.y;
			_cameraIsAtDesiredLoc();

func _adjustClock():
	if(int(SeasonClock.rotation_degrees) != desiredClockRot):
		SeasonClock.rotation_degrees += 1;
		if(SeasonClock.rotation_degrees > 359): SeasonClock.rotation_degrees = 0;
		if(int(SeasonClock.rotation_degrees) == desiredClockRot):
			# update clock rotation for singleton
			Clock_Rotate = int(SeasonClock.rotation_degrees);
			print("Overworld:: _adjustClock just arrived at "+str(int(SeasonClock.rotation_degrees)));

func _playerChoseNode(selectedNode:int):
	# player has clicked an accessible node
	print("Overworld:: _playerChoseNode "+str(selectedNode));
	PlayerIcon.get_child(0).stop();
	PlayerIcon.visible = false;
	
	# disable selection / all selectable nodes
	listeningForBtns = false;
	whichBtnHovered = -1;
	for thisChildIdx:int in range(PlayerCurrNode.childNodes.size()):
		var thisChildNode:OverworldNode = PlayerCurrNode.childNodes[thisChildIdx];
		thisChildNode.localSceneLink.get_child(MAPNODECHILD_LILYPAD).modulate = Color.WHITE;
		thisChildNode.localSceneLink.get_child(MAPNODECHILD_HALO).modulate = Color.WHITE;
		thisChildNode.localSceneLink.get_child(MAPNODECHILD_HALO).visible = false;
		thisChildNode.localSceneLink.get_child(MAPNODECHILD_BTN).button_pressed = false;
		thisChildNode.localSceneLink.get_child(MAPNODECHILD_BTN).visible = false;
	
	# act based on selection
	var leftOverworld:bool = PlayerCurrNode.childNodes[selectedNode].launch();
	if(leftOverworld == false):
		# did not leave the overworld.  need to clear this node
		PlayerCurrNode.childNodes[selectedNode].localSceneLink.get_child(MAPNODECHILD_ICON).get_child(0).stop();
		PlayerCurrNode.childNodes[selectedNode].localSceneLink.get_child(MAPNODECHILD_ICON).set_frame(OverworldNode.MAPNODETYPE_EMPTY);
		# need to run some checks again
		_findPlayerCurrNode();
		_updateVerticalMapProgress();

func _lookForBtnPress():
	# check all nodes accessible from PlayerCurrNode
	for thisChildIdx:int in range(PlayerCurrNode.childNodes.size()):
		var thisChildNode:OverworldNode = PlayerCurrNode.childNodes[thisChildIdx];
		if(thisChildNode.localSceneLink.get_child(MAPNODECHILD_BTN).button_pressed == true):
			listeningForBtns = false;
			thisChildNode.localSceneLink.get_child(MAPNODECHILD_BTN).button_pressed = false;
			_playerChoseNode(thisChildIdx);
			return;
		elif(thisChildNode.localSceneLink.get_child(MAPNODECHILD_BTN).is_hovered() == true && whichBtnHovered != thisChildIdx):
			whichBtnHovered = thisChildIdx;
			thisChildNode.localSceneLink.get_child(MAPNODECHILD_LILYPAD).modulate = Color.GREEN;
			thisChildNode.localSceneLink.get_child(MAPNODECHILD_HALO).modulate = Color.LIME_GREEN;
			pass;
		elif(thisChildNode.localSceneLink.get_child(MAPNODECHILD_BTN).is_hovered() == false && whichBtnHovered == thisChildIdx):
			whichBtnHovered = -1;
			thisChildNode.localSceneLink.get_child(MAPNODECHILD_LILYPAD).modulate = Color.WHITE;
			thisChildNode.localSceneLink.get_child(MAPNODECHILD_HALO).modulate = Color.WHITE;
			pass;

func _process(_delta):
	_adjustCamera();
	_adjustClock();
	if(listeningForBtns): _lookForBtnPress();

func _exit_tree():
	OverworldSingleton.saveStuff(self);
	OverworldSingleton.mapGetRoot().killLinks();
