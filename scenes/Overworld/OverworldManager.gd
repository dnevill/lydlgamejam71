class_name OverworldManager
extends Node

# Overworld Manager Singleton
# represents map progress as a whole,
# persists while Overworld scene is not active

var MapRoot:OverworldNode;

# variables from the scene we hold onto when it is unloaded
var Camera_CurrentY = null;

func mapGetRoot():
	print("OverworldManager:: mapGetRoot");
	return MapRoot;

func mapPopulate():
	print("OverworldManager:: mapPopulate");
	
	# hard coded
	MapRoot = OverworldNode.new(0);
	MapRoot.addChild(OverworldNode.new(1));
	MapRoot.addChild(OverworldNode.new(1));
	
	MapRoot.childNodes[0].addToChain(OverworldNode.new(3));
	MapRoot.childNodes[0].addToChain(OverworldNode.new(1));
	MapRoot.childNodes[0].addToChain(OverworldNode.new(4));
	MapRoot.childNodes[0].addToChain(OverworldNode.new(2));
	
	MapRoot.childNodes[1].addToChain(OverworldNode.new(4));
	MapRoot.childNodes[1].addToChain(OverworldNode.new(1));
	MapRoot.childNodes[1].addToChain(OverworldNode.new(1));
	MapRoot.childNodes[1].addToChain(OverworldNode.new(2));

func _ready():
	print("OverworldManager:: _ready");
	mapPopulate();

func loadStuff(CurrentWorld):
	print("OverworldManager:: loadStuff");
	# overworld scene is asking for data
	if(Camera_CurrentY != null):
		CurrentWorld.Camera_CurrentY = Camera_CurrentY;

func saveStuff(CurrentWorld):
	print("OverworldManager:: saveStuff");
	# overworld scene is being unloaded & giving data
	Camera_CurrentY = CurrentWorld.Camera_CurrentY;
