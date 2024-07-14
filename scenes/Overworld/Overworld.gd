extends Control
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

func _ready():
	# line up camera with center of map artwork
	CameraObj.position.x = -(size.x - BGArt.texture.get_width())/2;
	
	# if there was a stored camera Y, return there
	if(Camera_CurrentY != null):
		CameraObj.position.y = Camera_CurrentY;
	
	# spawn a map node
	var newMapNode = MapNodeSCENE.instantiate();
	newMapNode.position = Vector2(MapOriginX, MapOriginY);
	MapNodes.add_child(newMapNode);

func _process(_delta):
	# scroll camera down, stop at bottom of map artwork
	if(CameraObj.position.y < BGArt.texture.get_height() - size.y):
		CameraObj.position.y += 4;
		Camera_CurrentY = CameraObj.position.y;

func _exit_tree():
	OverworldSingleton.saveStuff(self);
