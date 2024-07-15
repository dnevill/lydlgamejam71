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
	var NN1b = OverworldNode.new(12);
	NN1.addChild(NN1a);
	NN1.addChild(NN1b);
	
	var NN1a1 = OverworldNode.new(111);
	NN1a.addChild(NN1a1);
	var NN1b1 = OverworldNode.new(121);
	NN1b.addChild(NN1b1);
	
	var NN2 = OverworldNode.new(2);
	var NN21 = OverworldNode.new(21);
	NN2.addChild(NN21);
	var NN211 = OverworldNode.new(211);
	NN21.addChild(NN211);
	
	var NN3 = OverworldNode.new(3);
	var NN31 = OverworldNode.new(31);
	NN3.addChild(NN31);
	var NN311 = OverworldNode.new(311);
	NN31.addChild(NN311);
	
	var NN311a = OverworldNode.new(3111);
	NN311.addChild(NN311a);
	var NN311b = OverworldNode.new(3112);
	NN311.addChild(NN311b);
	var NN311c = OverworldNode.new(3113);
	NN311.addChild(NN311c);
	
	var NN4 = OverworldNode.new(4);
	var NN41 = OverworldNode.new(41);
	NN4.addChild(NN41);
	var NN411 = OverworldNode.new(411);
	NN41.addChild(NN411);
	
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
