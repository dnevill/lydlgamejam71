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
	var NN1 = OverworldNode.new(1);
	var NN1a = OverworldNode.new(11);
	NN1.addChild(NN1a);
	
	var NN2 = OverworldNode.new(2);
	var NN2a = OverworldNode.new(11);
	var NN2b = OverworldNode.new(12);
	var NN2c = OverworldNode.new(13);
	NN2.addChild(NN2a);
	NN2.addChild(NN2b);
	NN2.addChild(NN2c);
	
	var NN3 = OverworldNode.new(3);
	
	var NN4 = OverworldNode.new(4);
	var NN4a = OverworldNode.new(11);
	var NN4b = OverworldNode.new(12);
	NN4.addChild(NN4a);
	NN4.addChild(NN4b);
	
	MapRoot.addChild(NN1);
	MapRoot.addChild(NN2);
	MapRoot.addChild(NN3);
	MapRoot.addChild(NN4);

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
