class_name OverworldMapGenerator
extends Resource

# aids in generating overworld maps

const FORBIDDEN_PAIRS:Array = [[2,1], [2,2], [3,3], [4,4], [5,5]];
const FORBIDDEN_REPLACER:Array = [OverworldNode.MAPNODETYPE_FOE, OverworldNode.MAPNODETYPE_BOOK];

static func createChain(requiredLength:int):
	# builds a chain of requiredLength random nodes and returns the root
	var resultNode:OverworldNode = OverworldNode.new(OverworldNode.MAPNODETYPE_RANDOM);
	for n in (requiredLength-1):
		resultNode.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_RANDOM));
	return resultNode;

static func findFinalNode(thisNode:OverworldNode):
	# recursively finds final node connected to this one, traveling down child 0
	if(thisNode.childNodes.size() < 1): return thisNode;
	return findFinalNode(thisNode.childNodes[0]);

static func scrubTree(thisNode:OverworldNode, previousNodeType:int):
	# recursively goes through a tree, looking for forbidden pairs
	# and replacing the 2nd node with a FORBIDDEN_REPLACER
	
	if(previousNodeType == OverworldNode.MAPNODETYPE_EMPTY):
		pass;
	else:
		for thisPairArr:Array in FORBIDDEN_PAIRS:
			if((thisPairArr[0] == previousNodeType) && (thisPairArr[1] == thisNode.nodeType)):
				thisNode.nodeType = FORBIDDEN_REPLACER[randi() % FORBIDDEN_REPLACER.size()];
	
	if(thisNode.childNodes.size() < 1): return;
	else:
		for thisChildIdx:int in range(thisNode.childNodes.size()):
			OverworldMapGenerator.scrubTree(thisNode.childNodes[thisChildIdx], thisNode.nodeType);
