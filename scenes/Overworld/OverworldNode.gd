class_name OverworldNode
extends Resource

var launched:bool = false;
var parentNode:OverworldNode = null;
var childNodes:Array = Array();
var widestBranch:int = 1;
var nodeType:int;

func _init(newNodeType:int):
	# constructor
	# newNodeType determines how it's drawn.  Will eventually pass in more info
	print("OverworldNode:: init type " + str(newNodeType));
	nodeType = newNodeType;

func updateWidest(newSize:int):
	# keep track of how many nodes, at widest, this tree has
	# this is necessary to know much space to give each branch
	if(newSize > widestBranch):
		widestBranch = newSize;
		if(parentNode != null):
			parentNode.updateWidest(newSize);

func addChild(newNode:OverworldNode):
	# add a child node to this node
	childNodes.push_back(newNode);
	newNode.parentNode = self;
	
	# it is possible that this is now the widest point in the tree
	updateWidest(max(childNodes.size(),newNode.widestBranch));

func addToChain(newNode:OverworldNode):
	# forms a chain (no-branch tree) if called repeatedly.
	if(childNodes.size() > 0):
		childNodes[0].addToChain(newNode);
	else:
		self.addChild(newNode);

func launch():
	print("OverworldNode:: launch type " + str(nodeType));
	# launch the activity that this overworld Node represents
	launched = true;
