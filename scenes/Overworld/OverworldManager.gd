class_name OverworldManager
extends Node

var MapRoot:OverworldNode;

# variables which need to be stored when overworld scene is unloaded
var Camera_CurrentY = null;

func mapGetRoot():
	print("OverworldManager:: mapGetRoot");
	return MapRoot;

func mapPopulate():
	print("OverworldManager:: mapPopulate");
	
	# hard coded
	MapRoot = OverworldNode.new(0);
	MapRoot.addToChain(OverworldNode.new(0));
	MapRoot.addToChain(OverworldNode.new(2));
	MapRoot.addToChain(OverworldNode.new(0));
	MapRoot.addToChain(OverworldNode.new(3));
	MapRoot.addToChain(OverworldNode.new(1));

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
